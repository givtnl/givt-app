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
    return SizedBox(
      height: 188,
      width: 253,
      child: Stack(
        children: [
          if (third != null)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: LeagueHighlightedHero(uiModel: third),
            ),
          if (second != null)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: LeagueHighlightedHero(uiModel: second),
            ),
          if (first != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LeagueHighlightedHero(
                uiModel: first,
                isLarge: true,
              ),
            ),
        ],
      ),
    );
  }
}
