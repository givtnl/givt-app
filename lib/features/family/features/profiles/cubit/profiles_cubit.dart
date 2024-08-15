import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';
//here

class ProfilesCubit extends HydratedCubit<ProfilesState> {
  ProfilesCubit(
    this._profilesRepository,
    this._authRepository,
    this._impactGroupsRepository,
  ) : super(const ProfilesInitialState()) {
    _init();
  }

  final ProfilesRepository _profilesRepository;
  final AuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  StreamSubscription<Profile>? _childDetailsSubscription;
  StreamSubscription<bool>? _hasSessionSubscription;

  void _init() {
    _profilesSubscription = _profilesRepository.onProfilesChanged().listen(
      (profiles) {
        fetchAllProfiles();
      },
    );
    _childDetailsSubscription = _profilesRepository.onChildChanged().listen(
      (profile) {
        fetchActiveProfile();
      },
    );
    _hasSessionSubscription = _authRepository.hasSessionStream().listen(
      (hasSession) {
        if (!hasSession) {
          emit(const ProfilesInitialState());
        }
      },
    );
  }

  Future<void> doInitialChecks() async {
    _emitLoadingState();
    await fetchAllProfiles(doChecks: true);
  }

  void _showInviteSheet(ImpactGroup impactGroup) {
    emit(
      ProfilesInvitedToGroup(
        profiles: state.profiles,
        activeProfileIndex: state.activeProfileIndex,
        impactGroup: impactGroup,
      ),
    );
  }

  Future<void> fetchAllProfiles({
    bool doChecks = false,
  }) async {
    _emitLoadingState();

    try {
      final newProfiles = <Profile>[];
      final response = await _profilesRepository.getProfiles();
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
      if (doChecks) {
        unawaited(_doChecks(newProfiles));
      }
      emit(
        ProfilesUpdatedState(
          profiles: newProfiles,
          activeProfileIndex: state.activeProfileIndex,
        ),
      );
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while fetching profiles: $error',
        methodName: stackTrace.toString(),
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

  Future<void> _doChecks(List<Profile> list) async {
    final group = await _impactGroupsRepository.isInvitedToGroup();
    if (group != null) {
      _showInviteSheet(group);
    } else {
      await _doRegistrationCheck(list);
    }
  }

  Future<void> _doRegistrationCheck(List<Profile> newProfiles) async {
    UserExt? userExternal;
    final (userExt, session, amountPresets) =
        await _authRepository.isAuthenticated() ?? (null, null, null);
    userExternal = userExt;

    if (userExternal?.needRegistration ?? false) {
      emit(
        ProfilesNeedsRegistration(
          profiles: newProfiles,
          activeProfileIndex: state.activeProfileIndex,
          hasFamily:
              newProfiles.where((p) => p.type.contains('Child')).isNotEmpty,
        ),
      );
    } else if (newProfiles.where((p) => p.type.contains('Child')).isEmpty) {
      emit(
        ProfilesNotSetupState(
          profiles: newProfiles,
          activeProfileIndex: state.activeProfileIndex,
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
    final profile = state.profiles.firstWhere(
      (element) => element.id == id,
      orElse: Profile.empty,
    );
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
      final response = await _profilesRepository.getChildDetails(childGuid);
      state.profiles[index] = response;
      emit(
        ProfilesUpdatedState(
          profiles: state.profiles,
          activeProfileIndex: index,
        ),
      );
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while fetching profiles: $error',
        methodName: stackTrace.toString(),
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
    _profilesSubscription?.cancel();
    _childDetailsSubscription?.cancel();
    return super.close();
  }
}
