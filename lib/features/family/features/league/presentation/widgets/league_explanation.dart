import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class LeagueExplanation extends StatelessWidget {
  const LeagueExplanation({super.key, this.onContinuePressed});

  final VoidCallback? onContinuePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/family/images/league/standing_superhero.svg',
          ),
          const SizedBox(height: 16),
          const TitleLargeText(
            'Welcome to the League!',
            textAlign: TextAlign.center,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: BodyMediumText(
              'Your XP sets your rank. Grow in generosity and climb to the top!',
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          FunButton(
            onTap: onContinuePressed,
            text: 'Continue',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.leagueExplanationContinueClicked,
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
