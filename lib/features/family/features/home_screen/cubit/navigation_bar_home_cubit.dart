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
import 'package:givt_app/features/family/features/tutorial/domain/tutorial_repository.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationBarHomeCubit
    extends CommonCubit<NavigationBarHomeScreenUIModel, NavigationBarHomeCustom>
    with BoxOriginUseCase, RegistrationUseCase {
  NavigationBarHomeCubit(
    this._authRepository,
    this._impactGroupsRepository,
    this._tutorialRepository,
  ) : super(const BaseState.loading());

  static const String _tutorialSeenOrSkippedKey = 'tutorialSeenOrSkippedKey';

  final FamilyAuthRepository _authRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final TutorialRepository _tutorialRepository;

  ImpactGroup? _familyInviteGroup;

  Future<void> init() async {
    _impactGroupsRepository.onImpactGroupsChanged().listen((_) {
      _onImpactGroupsChanged();
    });
    _authRepository.registrationFinishedStream().listen((_) {
      _doInitialChecks(fromRegistrationFinished: true);
    });
    await refreshData();
  }

  void switchTab(int tabIndex) {
    emitCustom(NavigationBarHomeCustom.switchTab(tabIndex));
  }

  Future<void> refreshData() async {
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    await _doInitialChecks();
    _emitData();
  }

  Future<void> _onImpactGroupsChanged() async {
    _familyInviteGroup = await _impactGroupsRepository.isInvitedToGroup();
    await _doInitialChecks();
    _emitData();
  }

  Future<void> _doInitialChecks({bool fromRegistrationFinished = false}) async {
    if (_familyInviteGroup != null) {
      await _setTutorialSeenOrSkipped();
      return;
    } else if (await userNeedsToFillInPersonalDetails()) {
      return;
    } else if (fromRegistrationFinished && _shouldShowTutorial()) {
      await _setTutorialSeenOrSkipped();
      //delay is to ensure screen is visible
      await Future.delayed(const Duration(milliseconds: 30));

      // Temp disabled tutorial popup
      // emitCustom(const NavigationBarHomeCustom.showTutorialPopup());
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

  void _emitData() {
    // Fetch all impact groups and find the family group
    _impactGroupsRepository.getImpactGroups().then((groups) {
      final familyGroup = groups.firstWhereOrNull((g) => g.isFamilyGroup);
      final showMemoriesTab = familyGroup?.boxOrigin?.mediumId?.toLowerCase() != 'FF8EC1E5-8D2F-4238-519C-08DC57CE1CE7'.toLowerCase();
      emitData(
        NavigationBarHomeScreenUIModel(
          familyInviteGroup: _familyInviteGroup,
          showMemoriesTab: showMemoriesTab,
        ),
      );
    });
  }

  Future<void> logout() async {
    await getIt<SharedPreferences>().remove(_tutorialSeenOrSkippedKey);
  }
}
