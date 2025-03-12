import 'dart:async';

import 'package:givt_app/features/family/features/league/domain/league_repository.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/models/league_screen_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class InGameLeagueCubit extends CommonCubit<LeagueScreenUIModel, dynamic> {
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

  Future<void> init() async {
    try {
      emitLoading();
      _shouldShowExplanation =
          1 == await _reflectAndShareRepository.getTotalGamePlays();
      _profiles = await _profilesRepository.getProfiles();
      _league = await _leagueRepository.fetchLeague();
    } catch (e, s) {
      // do nothing
    }
    _emitData();
  }

  void _emitData() {
    if (_shouldShowExplanation) {
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
    emitData(const LeagueScreenUIModel.showEmptyLeague());
  }

  void onExplanationContinuePressed() {
    _shouldShowExplanation = false;
    _emitData();
  }
}
