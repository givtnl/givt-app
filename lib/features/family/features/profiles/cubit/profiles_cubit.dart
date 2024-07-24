import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';

class ProfilesCubit extends HydratedCubit<ProfilesState> {
  ProfilesCubit(
    this._profilesRepositoy,
    this._addMemberRepository,
    this._authRepository,
    this._editChildRepository,
    this._impactGroupsRepository,
  ) : super(const ProfilesInitialState()) {
    _init();
  }

  final ProfilesRepository _profilesRepositoy;
  final AddMemberRepository _addMemberRepository;
  final AuthRepository _authRepository;
  final EditChildRepository _editChildRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  StreamSubscription<void>? _memberAddedSubscription;
  StreamSubscription<String>? _walletChangedSubscription;
  StreamSubscription<void>? _groupInviteAcceptedSubscription;
  ImpactGroup? _invitedToGroup;

  void _init() {
    _memberAddedSubscription = _addMemberRepository.memberAddedStream().listen(
      (_) {
        fetchAllProfiles();
      },
    );
    _walletChangedSubscription =
        _editChildRepository.walletChangedStream().listen(
      (childGuid) {
        fetchProfile(childGuid);
      },
    );
    _groupInviteAcceptedSubscription =
        _impactGroupsRepository.groupInviteAcceptedStream().listen(
      (_) {
        _invitedToGroup = null;
        fetchAllProfiles();
      },
    );
  }

  Future<void> doInitialChecks() async {
    _emitLoadingState();
    await checkIfInvitedToGroup();
    if (_isInvitedToGroup()) {
      _showInviteSheet();
    } else {
      await fetchAllProfiles(checkRegistrationAndSetup: true);
    }
  }

  bool _isInvitedToGroup() => _invitedToGroup != null;

  void _showInviteSheet() {
    emit(
      ProfilesInvitedToGroup(
        profiles: state.profiles,
        activeProfileIndex: state.activeProfileIndex,
        impactGroup: _invitedToGroup!,
      ),
    );
  }

  Future<void> checkIfInvitedToGroup() async {
    try {
      final impactGroups = await _impactGroupsRepository.fetchImpactGroups();
      for (final impactGroup in impactGroups) {
        if (impactGroup.status == ImpactGroupStatus.invited) {
          _invitedToGroup = impactGroup;
          break;
        }
      }
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(
        e,
        stacktrace: s,
      );
    }
  }

  Future<void> fetchAllProfiles({
    bool checkRegistrationAndSetup = false,
    bool checkInvite = false,
  }) async {
    _emitLoadingState();

    try {
      if (checkInvite) {
        await checkIfInvitedToGroup();
      }
      if (_isInvitedToGroup()) {
        _showInviteSheet();
        return;
      }

      final newProfiles = <Profile>[];
      final response = await _profilesRepositoy.fetchAllProfiles();
      newProfiles.addAll(response);

      for (final oldProfile in state.profiles) {
        final newProfile = response.firstWhere(
          (Profile element) => element.id == oldProfile.id,
          orElse: Profile.empty,
        );
        if (newProfile == Profile.empty()) {
          final updatedProfile = oldProfile.copyWith(
            firstName: newProfile.firstName,
            lastName: newProfile.lastName,
            pictureURL: newProfile.pictureURL,
          );
          newProfiles[state.profiles.indexOf(oldProfile)] = updatedProfile;
        }
      }
      UserExt? userExternal;
      if (checkRegistrationAndSetup) {
        // ignore: unused_local_variable
        final (userExt, session, amountPresets) =
            await _authRepository.isAuthenticated() ?? (null, null, null);
        userExternal = userExt;
      }

      if (userExternal?.needRegistration ?? false) {
        emit(
          ProfilesNeedsRegistration(
            profiles: newProfiles,
            activeProfileIndex: state.activeProfileIndex,
            hasFamily:
                newProfiles.where((p) => p.type.contains('Child')).isNotEmpty,
          ),
        );
      } else if (checkRegistrationAndSetup &&
          newProfiles.where((p) => p.type.contains('Child')).isEmpty) {
        emit(
          ProfilesNotSetupState(
            profiles: newProfiles,
            activeProfileIndex: state.activeProfileIndex,
          ),
        );
      }
      emit(
        ProfilesUpdatedState(
          profiles: newProfiles,
          activeProfileIndex: state.activeProfileIndex,
        ),
      );
    } catch (error, stackTrace) {
      unawaited(
        LoggingInfo.instance.error(
          'Error while fetching profiles: $error',
          methodName: stackTrace.toString(),
        ),
      );
      emit(
        ProfilesExternalErrorState(
          errorMessage: error.toString(),
          activeProfileIndex: state.activeProfileIndex,
          profiles: state.profiles,
        ),
      );
    }
  }

  void _emitLoadingState() {
    emit(
      ProfilesLoadingState(
        profiles: state.profiles,
        activeProfileIndex: state.activeProfileIndex,
      ),
    );
  }

  Future<void> fetchActiveProfile([bool forceLoading = false]) async {
    return fetchProfile(state.activeProfile.id, forceLoading);
  }

  Future<void> fetchProfile(String id, [bool forceLoading = false]) async {
    final profile = state.profiles.firstWhere((element) => element.id == id);
    final index = state.profiles.indexOf(profile);
    final childGuid = state.profiles[index].id;

    if (index == state.activeProfileIndex && !forceLoading) {
      // When updating the same profile, we don't want to show the loading state
      emit(
        ProfilesUpdatingState(
          profiles: state.profiles,
          activeProfileIndex: index,
        ),
      );
    } else {
      emit(
        ProfilesLoadingState(
          profiles: state.profiles,
          activeProfileIndex: index,
        ),
      );
    }
    try {
      final response = await _profilesRepositoy.fetchChildDetails(childGuid);
      state.profiles[index] = response;
      emit(
        ProfilesUpdatedState(
          profiles: state.profiles,
          activeProfileIndex: index,
        ),
      );
    } catch (error, stackTrace) {
      unawaited(
        LoggingInfo.instance.error(
          'Error while fetching profiles: $error',
          methodName: stackTrace.toString(),
        ),
      );

      emit(
        ProfilesExternalErrorState(
          errorMessage: error.toString(),
          activeProfileIndex: state.activeProfileIndex,
          profiles: state.profiles,
        ),
      );
    }
  }

  void clearProfiles() {
    emit(const ProfilesInitialState());
  }

  @override
  ProfilesState? fromJson(Map<String, dynamic> json) {
    log('fromJSON: $json');
    final profilesMap = jsonDecode(json['profiles'] as String);
    final activeProfileIndex = json['activeProfileIndex'] as int;
    final profiles = <Profile>[];
    for (final profileMap in profilesMap as List<dynamic>) {
      profiles.add(Profile.fromMap(profileMap as Map<String, dynamic>));
    }
    return ProfilesUpdatedState(
      profiles: profiles,
      activeProfileIndex: activeProfileIndex,
    );
  }

  @override
  Map<String, dynamic>? toJson(ProfilesState state) {
    final result = {
      'profiles': jsonEncode(state.profiles),
      'activeProfileIndex': state.activeProfileIndex,
    };
    return result;
  }

  @override
  Future<void> close() {
    _memberAddedSubscription?.cancel();
    _walletChangedSubscription?.cancel();
    _groupInviteAcceptedSubscription?.cancel();
    return super.close();
  }
}
