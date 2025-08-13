import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';

sealed class LeagueScreenUIModel {
  const LeagueScreenUIModel();

  const factory LeagueScreenUIModel.showLeague(
    LeagueOverviewUIModel uiModel,
  ) = ShowLeagueOverview;

  const factory LeagueScreenUIModel.showLeagueExplanation() = ShowLeagueExplanation;

  const factory LeagueScreenUIModel.showEmptyLeague({bool showGenerosityHunt}) = ShowEmptyLeague;
}

class ShowLeagueOverview extends LeagueScreenUIModel {
  const ShowLeagueOverview(this.uiModel);

  final LeagueOverviewUIModel uiModel;
}

class ShowLeagueExplanation extends LeagueScreenUIModel {
  const ShowLeagueExplanation();
}

class ShowEmptyLeague extends LeagueScreenUIModel {
  const ShowEmptyLeague({this.showGenerosityHunt = false});

  final bool showGenerosityHunt;
}
