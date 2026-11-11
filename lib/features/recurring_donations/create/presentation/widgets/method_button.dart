import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class MethodButton extends StatelessWidget {
  const MethodButton({
    required this.onPressed,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.analyticsEvent,
    super.key,
  });

  final VoidCallback onPressed;
  final String imagePath;
  final String title;
  final String subtitle;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      analyticsEvent: analyticsEvent,
      onTap: onPressed,
      borderColor: FunTheme.of(context).neutralVariant80,
      baseBorderSize: FunTheme.of(context).borderWidthThin,
      borderSize:
          FunTheme.of(context).borderWidthThin + FunTheme.of(context).shadowYSm,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: FunTheme.of(context).neutral98,
        ),
        child: Container(
          // Inner container to fix the inside border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: FunTheme.of(context).neutral98,
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: Image.asset(
                      imagePath,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LabelLargeText(
                          title,
                          color: FunTheme.of(context).highlight40,
                        ),
                        BodySmallText(
                          subtitle,
                          color: FunTheme.of(context).highlight40,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
