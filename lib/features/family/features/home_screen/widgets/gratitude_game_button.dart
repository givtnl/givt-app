import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class GratitudeGameButton extends StatelessWidget {
  const GratitudeGameButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ActionContainer(
      analyticsEvent: AmplitudeEvents.familyHomeScreenGratitudeGameButtonClicked.toEvent(),
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
              Row(
                children: [
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelLargeText(
                        l10n.homeScreenGratitudeGameButtonTitle,
                        color: FamilyAppTheme.highlight40,
                      ),
                      BodySmallText(
                        l10n.homeScreenGratitudeGameButtonSubtitle,
                        color: FamilyAppTheme.highlight40,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
