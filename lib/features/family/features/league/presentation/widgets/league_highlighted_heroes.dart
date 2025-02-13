import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/league_highlighted_hero.dart';
import 'package:givt_app/features/family/features/league/presentation/widgets/models/league_entry_uimodel.dart';

class LeagueHighlightedHeroes extends StatelessWidget {
  const LeagueHighlightedHeroes({required this.uiModels, super.key});

  final List<LeagueEntryUIModel> uiModels;

  @override
  Widget build(BuildContext context) {
    final shortlist = uiModels.take(3);
    final first = shortlist.firstOrNull;
    final second = shortlist.elementAtOrNull(1);
    final third = shortlist.elementAtOrNull(2);
    return Stack(
      children: [
        if (third != null)
          Positioned(
            right: 1,
            child: LeagueHighlightedHero(uiModel: third),
          ),
        if (second != null)
          Positioned(
            left: 1,
            child: LeagueHighlightedHero(uiModel: second),
          ),
        if (first != null)
          Positioned(
            left: 0,
            right: 0,
            child: LeagueHighlightedHero(uiModel: first),
          ),
      ],
    );
  }
}
