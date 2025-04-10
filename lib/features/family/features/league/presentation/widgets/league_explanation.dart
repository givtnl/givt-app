import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class LeagueExplanation extends StatelessWidget {
  const LeagueExplanation({
    super.key,
    this.onContinuePressed,
    this.isInGameVersion = false,
  });

  final bool isInGameVersion;
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
          TitleLargeText(
            isInGameVersion
                ? context.l10n.leagueUnlocked
                : context.l10n.leagueWelcome,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BodyMediumText(
              context.l10n.leagueExplanation,
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          FunButton(
            onTap: onContinuePressed,
            text: isInGameVersion
                ? context.l10n.leagueUnlockLeague
                : context.l10n.buttonContinue,
            analyticsEvent: AnalyticsEvent(
              isInGameVersion
                  ? AmplitudeEvents.unlockLeagueClicked
                  : AmplitudeEvents.leagueExplanationContinueClicked,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
