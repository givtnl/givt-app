import 'dart:async';

import 'package:collection/collection.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen_custom.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/family/features/missions/domain/entities/mission.dart';
import 'package:givt_app/features/family/features/missions/domain/repositories/mission_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/mission_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/tutorial/domain/tutorial_repository.dart';
import 'package:givt_app/features/family/features/unlocked_badge/repository/unlocked_badge_repository.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/user_ext.dart';

class FamilyHomeScreenCubit
    extends CommonCubit<FamilyHomeScreenUIModel, FamilyHomeScreenCustom> {
  FamilyHomeScreenCubit(
    this._profilesRepository,
    this._impactGroupsRepository,
    this._reflectAndShareRepository,
    this._familyAuthRepository,
    this._missionRepository,
    this._networkInfo,
    this._tutorialRepository,
    this._unlockedBadgeRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final ReflectAndShareRepository _reflectAndShareRepository;
  final FamilyAuthRepository _familyAuthRepository;
  final MissionRepository _missionRepository;
  final NetworkInfo _networkInfo;
  final TutorialRepository _tutorialRepository;
  final UnlockedBadgeRepository _unlockedBadgeRepository;

  List<Profile> profiles = [];
  ImpactGroup? _familyGroup;
  GameStats? _gameStats;
  MissionStats? _missionStats;

  Future<void> init() async {
    _profilesRepository.onProfilesChanged().listen(_onProfilesChanged);
    _impactGroupsRepository.onImpactGroupsChanged().listen(_onGroupsChanged);
    _reflectAndShareRepository.onFinishedAGame().listen(_onFinishedAGame);
    _familyAuthRepository.authenticatedUserStream().listen((user) async {
      await _handleUserUpdate(user);
    });
    _missionRepository.onMissionsUpdated().listen(_missionsChanged);

    unawaited(
      inTryCatchFinally(
        inTry: () async =>
            _missionsChanged(await _missionRepository.getMissions()),
      ),
    );
    _onProfilesChanged(await _profilesRepository.getProfiles());
    _onGroupsChanged(
      await _impactGroupsRepository.getImpactGroups(fetchWhenEmpty: true),
    );
    unawaited(_getGameStats());
    _emitData();
    _tutorialRepository.onStartTutorial().listen((_) {
      _startTutorial();
    });
  }

  void _missionsChanged(List<Mission> missions) {
    try {
      _missionStats = MissionStats(
        missionsToBeCompleted: missions.where((m) => !m.isCompleted()).length,
      );

      _emitData();
    } catch (e) {
      // do nothing
    }
  }

  Future<void> _handleUserUpdate(UserExt? user) async {
    if (user == null) {
      try {
        final session = await _familyAuthRepository.refreshToken();
        if (session.isExpired || !session.isLoggedIn) {
          LoggingInfo.instance.info(
            'Session is expired or not logged in, we will log out',
            methodName: 'FamilyHomeScreenCubit init',
          );
          logout();
        }
      } catch (e, s) {
        if (_networkInfo.isConnected) {
          LoggingInfo.instance.error(
            'Error refreshing token while we do have internet, we will logout: $e,\n\n$s',
            methodName: 'FamilyHomeScreenCubit init',
          );
          logout();
        } else {
          // do nothing, the app will show a no internet connection dialog
        }
      }
    } else {
      unawaited(_getGameStats());
    }
  }

  Future<void> _getGameStats() async {
    try {
      _gameStats = await _reflectAndShareRepository.getGameStats();
      _emitData();
    } catch (e) {
      // do nothing
    }
  }

  void logout() {
    _gameStats = null;
    _familyGroup = null;
    profiles = [];
  }

  void _onProfilesChanged(List<Profile> profiles) {
    this.profiles = profiles;
    _emitData();
  }

  void _onGroupsChanged(List<ImpactGroup> groups) {
    _familyGroup = groups.firstWhereOrNull(
      (element) => element.isFamilyGroup,
    );

    _emitData();
  }

  void _onFinishedAGame(void event) {
    _getGameStats();
  }

  void _emitData() {
    emitData(
      _createUIModel(),
    );
  }

  void _startTutorial() {
    emitCustom(
      FamilyHomeScreenCustom.openAvatarOverlay(
        _createUIModel(),
        withTutorial: true,
      ),
    );
  }

  FamilyHomeScreenUIModel _createUIModel() {
    _sortProfiles();
    final showBarcodeHunt = _familyGroup?.boxOrigin?.mediumId?.toLowerCase() ==
        'FF8EC1E5-8D2F-4238-519C-08DC57CE1CE7'.toLowerCase();
    return FamilyHomeScreenUIModel(
      avatars: profiles
          .map(
            (e) => AvatarUIModel(
              avatar: e.avatar,
              customAvatarUIModel: e.customAvatar?.toUIModel(),
              text: e.firstName,
              guid: e.id,
            ),
          )
          .toList(),
      familyGroupName: _familyGroup?.name,
      gameStats: _gameStats,
      missionStats: _missionStats,
      showBarcodeHunt: showBarcodeHunt,
    );
  }

  void _sortProfiles() {
    profiles.sort(
      (a, b) => a.isChild
          ? -1
          : b.isChild
              ? 1
              : 0,
    );
  }

  void onNextTutorialClicked() {
    if (_missionStats?.missionsToBeCompleted == 0 || _missionStats == null) {
      emitCustom(const FamilyHomeScreenCustom.slideCarousel(1));
    }
    emitCustom(const FamilyHomeScreenCustom.startTutorial());
  }

  void markAllFeaturesAsSeen(String userId) {
    _unlockedBadgeRepository.markAllFeaturesAsSeenForUser(userId);
  }

  Future<void> showRewardOverlay() async {
    await Future.delayed(const Duration(milliseconds: 100));
    emitCustom(
      FamilyHomeScreenCustom.openAvatarOverlay(
        _createUIModel(),
        withRewardText: true,
      ),
    );
  }
}
