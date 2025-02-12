import 'package:givt_app/features/family/features/league/domain/league_repository.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/league_screen_uimodel.dart';
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
  late bool _hasSeenLeagueExplanation;

  void init() {
    _hasSeenLeagueExplanation = _prefs.getBool(_leagueExplanationKey) ?? false;
    _emitData();
  }

  void _emitData() {
    if (!_hasSeenLeagueExplanation) {
      emitData(const LeagueScreenUIModel.showLeagueExplanation());
    } else {
      emitData(const LeagueScreenUIModel.showEmptyLeague());
    }
  }

  void onExplanationContinuePressed() {
    _hasSeenLeagueExplanation = true;
    _prefs.setBool(_leagueExplanationKey, true);
    _emitData();
  }
}
