import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';

sealed class LeagueScreenUIModel {
  const LeagueScreenUIModel();

  const factory LeagueScreenUIModel.showLeague(
    List<LeagueEntryUIModel> uiModels,
  ) = ShowLeague;

  const factory LeagueScreenUIModel.showLeagueExplanation() =
      LeagueExplanation;

  const factory LeagueScreenUIModel.showNoStatsToShow() = NoStatsToShow;
}

class ShowLeague extends LeagueScreenUIModel {
  const ShowLeague(this.uiModels);

  final List<LeagueEntryUIModel> uiModels;
}

class LeagueExplanation extends LeagueScreenUIModel {
  const LeagueExplanation();
}

class NoStatsToShow extends LeagueScreenUIModel {
  const NoStatsToShow();
}
