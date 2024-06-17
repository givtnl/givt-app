import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profiles_state.dart';

class ProfilesCubit extends HydratedCubit<ProfilesState> {
  ProfilesCubit(this._profilesRepositoy, this._addMemberRepository)
      : super(const ProfilesInitialState()) {
    _init();
  }

  final ProfilesRepository _profilesRepositoy;
  final AddMemberRepository _addMemberRepository;

  StreamSubscription<void>? _memberAddedSubscription;

  void _init() {
    hydrate();
    AnalyticsHelper.setUserProperties(
      userId: state.activeProfile.id,
      userProperties: {},
    );
    _memberAddedSubscription = _addMemberRepository.memberAddedStream().listen(
      (_) {
        fetchAllProfiles();
      },
    );
  }

  Future<void> fetchAllProfiles() async {
    emit(
      ProfilesLoadingState(
        profiles: state.profiles,
        activeProfileIndex: state.activeProfileIndex,
      ),
    );

    try {
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
      emit(
        ProfilesUpdatedState(
          profiles: newProfiles,
          activeProfileIndex: state.activeProfileIndex,
        ),
      );
      if (newProfiles.isEmpty) {
        emit(
          ProfilesNotSetupState(
            profiles: newProfiles,
            activeProfileIndex: state.activeProfileIndex,
          ),
        );
      }
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
    return super.close();
  }
}
