import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';
//here

class ProfilesCubit extends Cubit<ProfilesState> {
  ProfilesCubit(
    this._profilesRepository,
    this._authRepository,
    this._impactGroupsRepository,
  ) : super(const ProfilesInitialState()) {
    _init();
  }

  final ProfilesRepository _profilesRepository;
  final FamilyAuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  StreamSubscription<UserExt?>? _authenticatedUserSubscription;

  void _init() {
    _profilesSubscription = _profilesRepository.onProfilesChanged().listen(
      (profiles) {
        fetchAllProfiles();
      },
    );
    _authenticatedUserSubscription =
        _authRepository.authenticatedUserStream().listen(
      (user) {
        if (user != null) {
          if (state.profiles.where((e) => e.id == user.guid).isEmpty) {
            clearProfiles();
          }
          fetchAllProfiles();
        } else {
          clearProfiles();
        }
      },
    );
  }

  // Fetches the current profiles.
  // Does NOT refresh them, however if a refresh is triggered by another source it will await this refresh.
  Future<void> fetchAllProfiles() async {
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
      _emitProfilesUpdated(newProfiles);
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

  void _emitLoadingState() {
    emit(
      ProfilesLoadingState(
        profiles: state.profiles,
        activeProfileIndex: state.activeProfileIndex,
      ),
    );
  }

  void _emitProfilesUpdated(
    List<Profile> profiles,
  ) {
    int? newIndex;
    try {
      final currentId = state.profiles[state.activeProfileIndex].id;
      final newActiveProfile = profiles.firstWhere(
        (element) => element.id == currentId,
        orElse: Profile.empty,
      );
      newIndex = profiles.indexOf(newActiveProfile);
    } catch (e, s) {
      // we probably didn't have profiles before, ignore this error
    }

    emit(
      ProfilesUpdatedState(
        profiles: profiles,
        activeProfileIndex: newIndex ?? state.activeProfileIndex,
      ),
    );
  }

  Future<void> refresh() async => _profilesRepository.refreshProfiles();

  void setActiveProfile(String id) {
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
    _impactGroupsRepository.clearBoxOriginModalShown();
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
    _authenticatedUserSubscription?.cancel();
    return super.close();
  }
}
