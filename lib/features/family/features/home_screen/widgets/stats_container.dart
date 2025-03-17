import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/stats_chip.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_stats.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

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
      child: gameStats == null
          ? showLoadingState()
          : gameStats!.totalSecondsPlayed == 0
              ? showEmptyState(context)
              : showStatsColumn(),
    );
  }

  Widget showLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LabelMediumText('Game activity this week'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                context.goNamed(
                  FamilyPages.reflectIntro.name,
                );

                AnalyticsHelper.logEvent(eventName: 
                  AmplitudeEvents.familyHomeScreenStatsContainerClicked,
                );
              },
              child: const StatsChip(
                icon: FontAwesomeIcons.arrowDown,
                text: 'Play the Gratitude Game',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget showStatsColumn() {
    final minutes = (gameStats!.totalSecondsPlayed / 60).ceil();
    final minutesText = minutes == 1 ? ' min together' : ' mins together';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LabelMediumText('Game activity this week'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatsChip(
              icon: FontAwesomeIcons.solidClock,
              text: minutes.toString() + minutesText,
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
