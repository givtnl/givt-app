import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class MethodButton extends StatelessWidget {
  const MethodButton({
    required this.onPressed,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final VoidCallback onPressed;
  final String imagePath;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      analyticsEvent: AmplitudeEvents.debugButtonClicked.toEvent(),
      onTap: onPressed,
      borderColor: FunTheme.of(context).neutralVariant80,
      baseBorderSize: 4,
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
