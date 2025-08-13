import 'dart:async';

import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/family/features/league/domain/league_repository.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeagueCubit extends CommonCubit<LeagueScreenUIModel, dynamic> {
  LeagueCubit(
    this._profilesRepository,
    this._leagueRepository,
    this._prefs,
    this._impactGroupsRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final LeagueRepository _leagueRepository;
  final SharedPreferences _prefs;
  final ImpactGroupsRepository _impactGroupsRepository;

  static const String _leagueExplanationKey = 'leagueExplanation';

  List<Profile> _profiles = [];
  List<LeagueItem> _league = [];
  late bool _hasSeenLeagueExplanation;
  ImpactGroup? _familyGroup;

  StreamSubscription<List<Profile>>? _profilesSubscription;
  StreamSubscription<List<LeagueItem>>? _leagueSubscription;

  Future<void> init() async {
    _profilesSubscription ??=
        _profilesRepository.onProfilesChanged().listen((profiles) {
      _profiles = profiles;
      _emitData();
    });
    _leagueSubscription ??=
        _leagueRepository.onLeagueChanged().listen((league) {
      _league = league;
      _emitData();
    });
    _hasSeenLeagueExplanation = _prefs.getBool(_leagueExplanationKey) ?? false;
    try {
      emitLoading();
      _profiles = await _profilesRepository.getProfiles();
      _league = await _leagueRepository.fetchLeague();
      _familyGroup = await _impactGroupsRepository.getImpactGroups(fetchWhenEmpty: true)
          .then((groups) => groups.where((element) => element.isFamilyGroup).firstOrNull);
    } catch (e, s) {
      // do nothing
    }
    _emitData();
  }

  void _emitData() {
    if (!_hasSeenLeagueExplanation) {
      emitData(const LeagueScreenUIModel.showLeagueExplanation());
    } else if (_league.isEmpty) {
      _emitEmptyLeague();
    } else {
      final entries = LeagueEntryUIModel.listFromEntriesAndProfiles(
        _league,
        _profiles,
      );
      if (entries.isNotEmpty) {
        emitData(
          LeagueScreenUIModel.showLeague(
            LeagueOverviewUIModel(
              entries: entries,
            ),
          ),
        );
      } else {
        _emitEmptyLeague();
      }
    }
  }

  void _emitEmptyLeague() {
    final showGenerosityHunt = _familyGroup?.boxOrigin?.mediumId?.toLowerCase() ==
        'FF8EC1E5-8D2F-4238-519C-08DC57CE1CE7'.toLowerCase();
    emitData(LeagueScreenUIModel.showEmptyLeague(showGenerosityHunt: showGenerosityHunt));
  }

  void onExplanationContinuePressed() {
    _hasSeenLeagueExplanation = true;
    _prefs.setBool(_leagueExplanationKey, true);
    _emitData();
  }
}
