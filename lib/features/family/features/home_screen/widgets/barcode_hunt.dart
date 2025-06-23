import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class BarcodeHunt extends StatelessWidget {
  const BarcodeHunt({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.debugButtonClicked,
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
                    width: 170,
                    child: Image.asset(
                      'assets/family/images/home_screen/gratitude_tile.webp',
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
                        'Barcode Hunt',
                        color: FamilyAppTheme.highlight40,
                      ),
                      BodySmallText(
                        "Catch 'm all",
                        color: FamilyAppTheme.highlight40,
                        maxLines: 1,
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
