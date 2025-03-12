import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';

sealed class InGameLeagueScreenUIModel {
  const InGameLeagueScreenUIModel();

  const factory InGameLeagueScreenUIModel.showLeague(
    LeagueOverviewUIModel uiModel,
  ) = ShowLeagueOverview;

  const factory InGameLeagueScreenUIModel.showLeagueExplanation() = ShowLeagueExplanation;

  const factory InGameLeagueScreenUIModel.showWhosOnTop() = ShowWhosOnTop;
}

class ShowLeagueOverview extends InGameLeagueScreenUIModel {
  const ShowLeagueOverview(this.uiModel);

  final LeagueOverviewUIModel uiModel;
}

class ShowLeagueExplanation extends InGameLeagueScreenUIModel {
  const ShowLeagueExplanation();
}

class ShowWhosOnTop extends InGameLeagueScreenUIModel {
  const ShowWhosOnTop();
}
