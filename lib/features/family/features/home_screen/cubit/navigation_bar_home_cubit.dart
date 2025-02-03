import 'dart:async';

import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/box_origin/usecases/box_origin_usecase.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_screen_uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/usecases/registration_usecase.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/tutorial/domain/tutorial_repository.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationBarHomeCubit
    extends CommonCubit<NavigationBarHomeScreenUIModel, NavigationBarHomeCustom>
    with BoxOriginUseCase, RegistrationUseCase {
  NavigationBarHomeCubit(
    this._profilesRepository,
    this._authRepository,
    this._impactGroupsRepository,
    this._tutorialRepository,
  ) : super(const BaseState.loading());

  static const String _tutorialSeenOrSkippedKey = 'tutorialSeenOrSkippedKey';

  final ProfilesRepository _profilesRepository;
  final FamilyAuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final TutorialRepository _tutorialRepository;

  String? profilePictureUrl;
  List<Profile> _profiles = [];
  ImpactGroup? _familyInviteGroup;

  Future<void> init() async {
    _profilesRepository.onProfilesChanged().listen(_onProfilesChanged);
    _impactGroupsRepository.onImpactGroupsChanged().listen((_) {
      _onImpactGroupsChanged();
    });
    _authRepository.registrationFinishedStream().listen((_) {
      _doInitialChecks();
    });
    await refreshData();
  }

  void switchTab(int tabIndex) {
    emitCustom(NavigationBarHomeCustom.switchTab(tabIndex));
  }

  Future<void> refreshData() async {
    _profiles = await _profilesRepository.getProfiles();
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    unawaited(_getProfilePictureUrl());
    await _doInitialChecks();
  }

  Future<void> _onImpactGroupsChanged() async {
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    await _doInitialChecks();
    _emitData();
  }

  Future<void> _onProfilesChanged(List<Profile> profiles) async {
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    _profiles = profiles;
    unawaited(_getProfilePictureUrl());
    await _doInitialChecks();
  }

  Future<void> _doInitialChecks() async {
    if (_familyInviteGroup != null) {
      return;
    } else if (await userNeedsToFillInPersonalDetails()) {
      return;
    } else if (_shouldShowTutorial()) {
      //delay is to ensure screen is visible
      await Future.delayed(const Duration(milliseconds: 30));
      await _setTutorialSeenOrSkipped();
      emitCustom(const NavigationBarHomeCustom.showTutorialPopup());
    }
  }

  bool _shouldShowTutorial() {
    return !_authRepository.hasUserStartedRegistration() &&
        !_hasSeenOrSkippedTutorial();
  }

  void onShowTutorialClicked() {
    _tutorialRepository.startTutorial();
  }

  bool _hasSeenOrSkippedTutorial() =>
      getIt<SharedPreferences>().containsKey(_tutorialSeenOrSkippedKey);

  Future<void> _setTutorialSeenOrSkipped() async =>
      getIt<SharedPreferences>().setBool(_tutorialSeenOrSkippedKey, true);

  Future<ImpactGroup?> isInvitedToGroup() async {
    try {
      return _impactGroupsRepository.isInvitedToGroup();
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      return null;
    }
  }

  Future<void> _getProfilePictureUrl() async {
    try {
      final session = await _authRepository.getStoredSession();
      final profile = _profiles
          .firstWhereOrNull((element) => element.id == session.userGUID);
      profilePictureUrl = profile?.pictureURL;

      if (_profiles.isNotEmpty) {
        _emitData();
      }
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
  }

  void _emitData() {
    emitData(
      NavigationBarHomeScreenUIModel(
        profilePictureUrl: profilePictureUrl,
        familyInviteGroup: _familyInviteGroup,
      ),
    );
  }

  Future<void> logout() async {
    await getIt<SharedPreferences>().remove(_tutorialSeenOrSkippedKey);
  }
}
