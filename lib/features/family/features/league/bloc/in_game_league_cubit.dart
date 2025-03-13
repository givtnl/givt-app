import 'dart:async';

import 'package:givt_app/features/family/features/league/domain/league_repository.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/in_game_league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class InGameLeagueCubit
    extends CommonCubit<InGameLeagueScreenUIModel, dynamic> {
  InGameLeagueCubit(
    this._profilesRepository,
    this._leagueRepository,
    this._reflectAndShareRepository,
  ) : super(const BaseState.loading());

  final ProfilesRepository _profilesRepository;
  final LeagueRepository _leagueRepository;
  final ReflectAndShareRepository _reflectAndShareRepository;

  List<Profile> _profiles = [];
  List<LeagueItem> _league = [];
  bool _shouldShowExplanation = false;
  bool _shouldShowOnTopOfLeague = false;

  Future<void> init() async {
    try {
      emitLoading();
      _shouldShowExplanation =
          1 == await _reflectAndShareRepository.getTotalGamePlays();
      _shouldShowOnTopOfLeague = !_shouldShowExplanation;
      _profiles = await _profilesRepository.getProfiles();
      _league = await _leagueRepository.fetchLeague();
    } catch (e, s) {
      // do nothing
    }
    _emitData();
  }

  void _emitData() {
    if (_league.isEmpty) {
      //skip
      emitCustom(null);
    } else if (_shouldShowExplanation) {
      emitData(const InGameLeagueScreenUIModel.showLeagueExplanation());
    } else if (_shouldShowOnTopOfLeague) {
      emitData(const InGameLeagueScreenUIModel.showWhosOnTop());
    } else {
      final entries = LeagueEntryUIModel.listFromEntriesAndProfiles(
        _league,
        _profiles,
      );
      emitData(
        InGameLeagueScreenUIModel.showLeague(
          LeagueOverviewUIModel(entries: entries, isInGameVersion: true),
        ),
      );
    }
  }

  void onExplanationContinuePressed() {
    _shouldShowExplanation = false;
    _shouldShowOnTopOfLeague = true;
    _emitData();
  }

  void onWhosTopOfLeagueContinuePressed() {
    _shouldShowOnTopOfLeague = false;
    _emitData();
  }

  void onLeagueOverviewContinuePressed() {
    emitCustom(null);
  }
}
