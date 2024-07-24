import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/pages/generosity_challenge_vpc_setup_page.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/utils.dart';

class Day8ExtraButton extends StatelessWidget {
  const Day8ExtraButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: () {
          AnalyticsHelper.logEvent(
              eventName:
                  AmplitudeEvents.generosityChallengeDay8MaybeLaterClicked);

          Navigator.of(context).push(
            const GenerosityChallengeVpcSetupPage().toRoute(
              context,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Maybe later',
              style: FamilyAppTheme()
                  .toThemeData()
                  .textTheme
                  .labelMedium
                  ?.copyWith(
                    color: AppTheme.error30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
            ),
            const SizedBox(width: 8),
            const FaIcon(
              FontAwesomeIcons.arrowRight,
              color: AppTheme.error30,
            ),
          ],
        ),
      ),
    );
  }
}
