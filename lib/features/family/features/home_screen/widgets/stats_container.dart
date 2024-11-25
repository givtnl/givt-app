import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/stats_chip.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class StatsContainer extends StatelessWidget {
  const StatsContainer(this.gameStats, {super.key});

  final GameStats? gameStats;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FamilyAppTheme.primary98,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      child: gameStats == null || gameStats!.totalSecondsPlayed == 0
          ? showEmptyState()
          : showStatsColumn(),
    );
  }

  Widget showEmptyState() {
    return const Column(
      children: [
        LabelMediumText('Your stats this week'),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsChip(
              icon: FontAwesomeIcons.arrowDown,
              text: 'Play the gratitude game'
            ),
          ],
        ),
      ],
    );
  }

  Widget showStatsColumn() {
    return Column(
      children: [
        const LabelMediumText('Your stats this week'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsChip(
              icon: FontAwesomeIcons.solidClock,
              text:
                  '${(gameStats!.totalSecondsPlayed / 60).ceil()} min together',
            ),
            StatsChip(
              icon: FontAwesomeIcons.solidHeart,
              text: '${gameStats!.totalActions} deeds',
            ),
          ],
        ),
      ],
    );
  }
}
