import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';

class EmptyLeague extends StatelessWidget {
  const EmptyLeague({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          'assets/family/images/league/league_empty_image.svg',
        ),
        const SizedBox(height: 16),
        const TitleMediumText(
          'Play the Gratitude Game to unlock this weeks League!',
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FunButton(
          onTap: () => context.goNamed(
            FamilyPages.reflectIntro.name,
          ),
          text: 'Play Gratitude Game',
          analyticsEvent:
          AnalyticsEvent(AmplitudeEvents.leaguePlayGameClicked),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
