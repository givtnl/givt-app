import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_entry_list.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_highlighted_heroes.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_overview_uimodel.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class LeagueOverview extends StatelessWidget {
  const LeagueOverview(
      {required this.uiModel, required this.dateLabel, super.key});

  final LeagueOverviewUIModel uiModel;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TitleLargeText('Heroes of the Week'),
          ),
          const SizedBox(height: 8),
          FunTag.tertiary(
            text: dateLabel,
            iconData: FontAwesomeIcons.solidClock,
            iconSize: 12,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          const SizedBox(height: 32),
          if (uiModel.entries != null)
            LeagueHighlightedHeroes(uiModels: uiModel.entries!),
          const SizedBox(height: 16),
          if (uiModel.entries != null)
            LeagueEntryList(
              physics: const ClampingScrollPhysics(),
              uiModels: uiModel.entries!,
              shrinkWrap: true,
            ),
        ],
      ),
    );
  }
}
