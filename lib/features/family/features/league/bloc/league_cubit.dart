import 'dart:async';

import 'package:collection/collection.dart';
import 'package:givt_app/features/family/features/league/domain/league_repository.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeagueCubit extends CommonCubit<LeagueScreenUIModel, dynamic> {
  LeagueCubit(
    this._profilesRepository,
    this._leagueRepository,
    this._prefs,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final LeagueRepository _leagueRepository;
  final SharedPreferences _prefs;

  static const String _leagueExplanationKey = 'leagueExplanation';

  List<Profile> _profiles = [];
  List<LeagueItem> _league = [];
  late bool _hasSeenLeagueExplanation;

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
      final entries = _organizeEntries();
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
    emitData(const LeagueScreenUIModel.showEmptyLeague());
  }

  // Match profiles to xp entries
  // Calculate rank
  // Sort on xp, then alphabetically
  List<LeagueEntryUIModel> _organizeEntries() {
    final listOfUniqueAndSortedExperiencePoints = _league
        .map((e) => e.experiencePoints)
        .toSet()
        .toList()
      ..sort((a, b) => b!.compareTo(a!));
    final list = _league.mapIndexed((int index, e) {
      final profile = _profiles.firstWhere(
        (p) => p.id == e.guid,
        orElse: Profile.empty,
      );
      final rank = listOfUniqueAndSortedExperiencePoints
              .where(
                (xp) => xp! > e.experiencePoints!,
              )
              .length +
          1;
      return LeagueEntryUIModel(
        rank: rank,
        name: profile.firstName,
        xp: e.experiencePoints,
        imageUrl: profile.pictureURL,
      );
    }).toList()
      ..removeWhere(
        (e) => e.name.isNullOrEmpty(),
      ) //we're waiting on a profiles update
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''))
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return list;
  }

  void onExplanationContinuePressed() {
    _hasSeenLeagueExplanation = true;
    _prefs.setBool(_leagueExplanationKey, true);
    _emitData();
  }
}
