import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/add_member/pages/family_member_form_page.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
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
  ImpactGroup? _familyGroup;

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
    
    // Listen to impact groups changes to track family group
    _impactGroupsRepository.onImpactGroupsChanged().listen(_onGroupsChanged);
    
    // Initialize by fetching impact groups
    _initImpactGroups();
  }

  Future<void> _initImpactGroups() async {
    try {
      final groups = await _impactGroupsRepository.getImpactGroups(fetchWhenEmpty: true);
      _onGroupsChanged(groups);
    } catch (e) {
      // Handle error silently, the flag will remain false
    }
  }

  void _onGroupsChanged(List<ImpactGroup> groups) {
    _familyGroup = groups.firstWhereOrNull(
      (element) => element.isFamilyGroup,
    );
    _emitData();
  }

  void _emitLoadingState() {
    emit(
      ProfilesLoadingState(
        profiles: state.profiles,
        activeProfileIndex: state.activeProfileIndex,
        showBarcodeHunt: _calculateShowBarcodeHunt(),
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
    } catch (e) {
      // we probably didn't have profiles before, ignore this error
    }

    emit(
      ProfilesUpdatedState(
        profiles: profiles,
        activeProfileIndex: newIndex ?? state.activeProfileIndex,
        showBarcodeHunt: _calculateShowBarcodeHunt(),
      ),
    );
  }

  bool _calculateShowBarcodeHunt() {
    return _familyGroup?.boxOrigin?.mediumId?.toLowerCase() ==
        'FF8EC1E5-8D2F-4238-519C-08DC57CE1CE7'.toLowerCase();
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
            avatar: newProfile.avatar,
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
          showBarcodeHunt: _calculateShowBarcodeHunt(),
        ),
      );
    }
  }

  void _emitData() {
    _emitProfilesUpdated(state.profiles);
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
          showBarcodeHunt: _calculateShowBarcodeHunt(),
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
          showBarcodeHunt: _calculateShowBarcodeHunt(),
        ),
      );
    }
  }

  void logout() {
    _familyGroup = null;
    emit(const ProfilesInitialState());
    _impactGroupsRepository.clearBoxOriginModalShown();
  }

  void clearProfiles({bool clearIndex = true}) {
    emit(
      ProfilesInitialState(
        activeProfileIndex: clearIndex
            ? ProfilesState._loggedInUserSelected
            : state.activeProfileIndex,
        showBarcodeHunt: _calculateShowBarcodeHunt(),
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
