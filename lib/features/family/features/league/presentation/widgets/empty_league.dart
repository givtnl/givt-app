import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:go_router/go_router.dart';

class EmptyLeague extends StatelessWidget {
  const EmptyLeague({required this.showGenerosityHunt, super.key});

  final bool showGenerosityHunt;

  @override
  Widget build(BuildContext context) {
    final titleText = showGenerosityHunt
        ? "Play the Generosity Hunt to unlock this week's League!"
        : "Play the Gratitude Game to unlock this week's League!";

    final buttonText =
        showGenerosityHunt ? 'Play Generosity Hunt' : 'Play Gratitude Game';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/family/images/league/league_empty_image.svg',
          ),
          const SizedBox(height: 16),
          TitleMediumText(
            titleText,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (!showGenerosityHunt) ...[
            FunButton(
              onTap: () => context.goNamed(
                FamilyPages.reflectIntro.name,
              ),
              text: buttonText,
              analyticsEvent: AnalyticsEventName.leaguePlayGameClicked.toEvent(),
            ),
            const SizedBox(height: 36),
          ],
        ],
      ),
    );
  }
}
