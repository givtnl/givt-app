import 'package:collection/collection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/models/parent_summary_item.dart';
import 'package:givt_app/features/family/features/gratitude-summary/domain/repositories/parent_summary_repository.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/avatar_uimodel.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyHomeScreenCubit
    extends CommonCubit<FamilyHomeScreenUIModel, FamilyHomeScreenUIModel> {
  FamilyHomeScreenCubit(
    this._profilesRepository,
    this._impactGroupsRepository,
    this._reflectAndShareRepository,
    this._summaryRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final ImpactGroupsRepository _impactGroupsRepository;
  final ReflectAndShareRepository _reflectAndShareRepository;
  final ParentSummaryRepository _summaryRepository;
  List<Profile> profiles = [];
  ImpactGroup? _familyGroup;
  GameStats? _gameStats;
  ParentSummaryItem? _latestSummary;

  Future<void> init() async {
    _profilesRepository.onProfilesChanged().listen(_onProfilesChanged);
    _impactGroupsRepository.onImpactGroupsChanged().listen(_onGroupsChanged);
    _reflectAndShareRepository.onGameStatsChanged().listen(_onGameStatsChanged);

    _onProfilesChanged(await _profilesRepository.getProfiles());
    _onGroupsChanged(
      await _impactGroupsRepository.getImpactGroups(fetchWhenEmpty: true),
    );
    _gameStats = await _reflectAndShareRepository.getGameStats();
    _emitData();
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

  void _onGameStatsChanged(GameStats gameStats) {
    _gameStats = gameStats;
    _emitData();
    _getLatestGameSummary();
  }

  Future<void> _getLatestGameSummary() async {
    try {
      _latestSummary = await _summaryRepository.fetchLatestGameSummary();
      _emitData();
    } catch (e, s) {
      // do nothing, we don't have a summary that's all
    }
  }

  void onGiveButtonPressed() {
    emitCustom(_createUIModel());
  }

  void _emitData() {
    emitData(
      _createUIModel(),
    );
  }

  FamilyHomeScreenUIModel _createUIModel() {
    _sortProfiles();
    return FamilyHomeScreenUIModel(
      avatars: profiles
          .map(
            (e) => AvatarUIModel(
              avatarUrl: e.pictureURL,
              text: e.firstName,
            ),
          )
          .toList(),
      familyGroupName: _familyGroup?.name,
      gameStats: _gameStats,
      showLatestSummaryBtn:
          _latestSummary != null && !_latestSummary!.isEmpty(),
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
}
