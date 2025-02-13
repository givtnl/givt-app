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
  LeagueCubit(this._profilesRepository, this._leagueRepository, this._prefs)
      : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final LeagueRepository _leagueRepository;
  final SharedPreferences _prefs;

  static const String _leagueExplanationKey = 'leagueExplanation';

  List<Profile> _profiles = [];
  List<LeagueItem> _league = [];
  late bool _hasSeenLeagueExplanation;
  late DateTime mondayMidnight;
  late int daysDifference;
  late int minutesDifference;

  Future<void> init() async {
    _calculateDatesAndTimes();
    _profilesRepository.onProfilesChanged().listen((profiles) {
      _profiles = profiles;
      _emitData();
    });
    _leagueRepository.onLeagueChanged().listen((league) {
      _league = league;
      _emitData();
    });
    _hasSeenLeagueExplanation = _prefs.getBool(_leagueExplanationKey) ?? false;
    try {
      _profiles = await _profilesRepository.getProfiles();
      _league = await _leagueRepository.getLeague();
    } catch (e, s) {
      // do nothing
    }
    _emitData();
  }

  void _calculateDatesAndTimes() {
    final now = DateTime.now();
    mondayMidnight = now.add(
      Duration(
        days: (DateTime.monday - now.weekday) % DateTime.daysPerWeek,
      ),
    )..subtract(
        Duration(
          hours: now.hour,
          minutes: now.minute,
          seconds: now.second,
          milliseconds: now.millisecond,
          microseconds: now.microsecond,
        ),
      );
    daysDifference = mondayMidnight.difference(now).inDays;
    minutesDifference = mondayMidnight.difference(now).inMinutes;
  }

  void _emitData() {
    if (!_hasSeenLeagueExplanation) {
      emitData(const LeagueScreenUIModel.showLeagueExplanation());
    } else if (_league.isEmpty) {
      emitData(const LeagueScreenUIModel.showEmptyLeague());
    } else {
      emitData(
        LeagueScreenUIModel.showLeague(
          LeagueOverviewUIModel(
            entries: _league.map((e) {
              final profile = _profiles.firstWhere(
                (p) => p.id == e.guid,
                orElse: Profile.empty,
              );
              return LeagueEntryUIModel(
                rank: 1,
                name: profile.firstName,
                xp: e.experiencePoints,
                imageUrl: profile.pictureURL,
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  void onExplanationContinuePressed() {
    _hasSeenLeagueExplanation = true;
    _prefs.setBool(_leagueExplanationKey, true);
    _emitData();
  }
}
