import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/actions/actions.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class WhosOnTopOfTheLeague extends StatelessWidget {
  const WhosOnTopOfTheLeague({super.key, this.onButtonPressed});

  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/family/images/league/top_heroes_reveal.svg',
          ),
          const SizedBox(height: 16),
          const TitleMediumText(
            'Who’s on top of the league? Let’s find out!',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          FunButton(
            onTap: onButtonPressed,
            text: 'Reveal',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.leagueButtonClicked,
              parameters: {'text': 'Reveal'},
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
