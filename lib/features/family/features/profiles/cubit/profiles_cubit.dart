import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/cached_members/repositories/cached_members_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';
//here

class ProfilesCubit extends Cubit<ProfilesState> {
  ProfilesCubit(
    this._profilesRepository,
    this._authRepository,
    this._impactGroupsRepository,
    this._cachedMembersRepository,
  ) : super(const ProfilesInitialState()) {
    _init();
  }

  final ProfilesRepository _profilesRepository;
  final AuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final CachedMembersRepository _cachedMembersRepository;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  StreamSubscription<bool>? _hasSessionSubscription;
  StreamSubscription<List<Member>>? _cachedMembersSubscription;

  void _init() {
    _profilesSubscription = _profilesRepository.onProfilesChanged().listen(
      (profiles) {
        fetchAllProfiles();
      },
    );
    _cachedMembersSubscription =
        _cachedMembersRepository.onCachedMembersChanged().listen(
      (members) {
        _emitProfilesUpdatedWithCachedMembers(state.profiles, members);
      },
    );
    _hasSessionSubscription = _authRepository.hasSessionStream().listen(
      (hasSession) {
        if (hasSession) {
          clearProfiles(clearIndex: false);
          fetchAllProfiles();
        } else {
          clearProfiles();
        }
      },
    );
  }

  Future<void> doInitialChecks() async {
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
      final cachedMembers = await cachedMembersCheck();
      if (doChecks) {
        unawaited(_doChecks(newProfiles, cachedMembers));
      }
      _emitProfilesUpdatedWithCachedMembers(newProfiles, cachedMembers);
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

  Future<void> _doChecks(List<Profile> list, List<Member> members) async {
    final group = await _impactGroupsRepository.isInvitedToGroup();
    if (group != null) {
      _showInviteSheet(group);
    } else {
      await _doRegistrationCheck(list, members);
    }
  }

  Future<List<Member>> cachedMembersCheck() async {
    var cachedMembers = <Member>[];

    try {
      final members = await _cachedMembersRepository.loadFromCache();
      cachedMembers = members;
    } on Exception catch (e, s) {
      LoggingInfo.instance.error(
        'Error while fetching profiles: $e',
        methodName: s.toString(),
      );
    }
    return cachedMembers;
  }

  Future<bool> _doRegistrationCheck(
    List<Profile> newProfiles,
    List<Member> members,
  ) async {
    try {
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
        return true;
      } else if (newProfiles.length <= 1) {
        emit(
          ProfilesNotSetupState(
            profiles: newProfiles,
            activeProfileIndex: state.activeProfileIndex,
            cachedMembers: members,
          ),
        );
        return true;
      }
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(
        e,
        stacktrace: s,
      );
    }
    return false;
  }

  void _emitLoadingState() {
    emit(
      ProfilesLoadingState(
        profiles: state.profiles,
        activeProfileIndex: state.activeProfileIndex,
      ),
    );
  }

  void _emitProfilesUpdatedWithCachedMembers(
    List<Profile> profiles,
    List<Member> members,
  ) {
    emit(
      ProfilesUpdatedState(
        profiles: profiles,
        activeProfileIndex: state.activeProfileIndex,
        cachedMembers: members,
      ),
    );
  }

  Future<void> refresh() async => _profilesRepository.refreshProfiles();

  Future<void> setActiveProfile(String id) async {
    try {
      final profile = state.profiles.firstWhere(
        (element) => element.id == id,
        orElse: Profile.empty,
      );
      final index = state.profiles.indexOf(profile);

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

  void logout() {
    clearProfiles();
    _impactGroupsRepository.clearPreferredChurchModalShown();
  }

  void clearProfiles({bool clearIndex = true}) {
    emit(
      ProfilesInitialState(
        activeProfileIndex: clearIndex
            ? ProfilesState._loggedInUserSelected
            : state.activeProfileIndex,
      ),
    );
  }

  @override
  Future<void> close() {
    _profilesSubscription?.cancel();
    _hasSessionSubscription?.cancel();
    _cachedMembersSubscription?.cancel();
    return super.close();
  }
}
