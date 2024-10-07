import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class GiveButton extends StatelessWidget {
  const GiveButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.FamilyHomeScreenGiveButtonClicked,
      ),
      onTap: onPressed,
      borderColor: FamilyAppTheme.secondary80,
      baseBorderSize: 4,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: FamilyAppTheme.secondary98,
        ),
        child: Container(
          // Inner container to fix the inside border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: FamilyAppTheme.secondary98,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/family/images/home_screen/hands.svg',
                  ),
                  const Spacer(),
                ],
              ),
              const Row(
                children: [
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LabelLargeText(
                        'Give',
                        color: FamilyAppTheme.secondary40,
                      ),
                      BodySmallText(
                        'Donate to a cause',
                        color: FamilyAppTheme.secondary40,
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
