import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class GenerosityHuntButton extends StatelessWidget {
  const GenerosityHuntButton({
    required this.onPressed,
    this.analyticsEvent,
    super.key,
  });

  final VoidCallback onPressed;
  final AnalyticsEvent? analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      analyticsEvent: analyticsEvent ?? AmplitudeEvents.homeGenerosityHuntButtonClicked.toEvent(),
      onTap: onPressed,
      borderColor: FamilyAppTheme.highlight80,
      baseBorderSize: 4,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: FamilyAppTheme.highlight98,
        ),
        child: Container(
          // Inner container to fix the inside border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: FamilyAppTheme.highlight98,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: SizedBox(
                      width: 170,
                      child: SvgPicture.asset(
                        'assets/family/images/home_screen/generosity_hunt_button.svg',
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Row(
                children: [
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelLargeText(
                        'Generosity Hunt',
                        color: FamilyAppTheme.highlight40,
                      ),
                      BodySmallText(
                        'Scan products,\nhunt for Givt Credits',
                        color: FamilyAppTheme.highlight40,
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
