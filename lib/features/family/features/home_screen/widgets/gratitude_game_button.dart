import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class GratitudeGameButton extends StatelessWidget {
  const GratitudeGameButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.FamilyHomeScreenGratitudeGameButtonClicked,
      ),
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
                  SizedBox(
                    width: 180,
                    child: Image.asset(
                      'assets/family/images/home_screen/super_show.png',
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
                        'Gratitude Game',
                        color: FamilyAppTheme.highlight40,
                      ),
                      BodySmallText(
                        'Family activity',
                        color: FamilyAppTheme.highlight40,
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
