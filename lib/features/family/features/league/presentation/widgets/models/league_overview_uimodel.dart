import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';

class LeagueOverviewUIModel {
  LeagueOverviewUIModel({
    this.entries,
    this.isInGameVersion = false,
  });

  final List<LeagueEntryUIModel>? entries;
  final bool isInGameVersion;
}
