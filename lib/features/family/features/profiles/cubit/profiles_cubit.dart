import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
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
  final AuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  StreamSubscription<bool>? _hasSessionSubscription;

  void _init() {
    _profilesSubscription = _profilesRepository.onProfilesChanged().listen(
      (profiles) {
        fetchAllProfiles();
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
    emit(
      ProfilesUpdatedState(
        profiles: profiles,
        activeProfileIndex: state.activeProfileIndex,
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
    return super.close();
  }
}
