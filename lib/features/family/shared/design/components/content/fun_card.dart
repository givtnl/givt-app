import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class FunCard extends StatelessWidget {
  const FunCard({
    this.icon,
    this.title,
    this.backgroundColor,
    this.content,
    this.button,
    super.key,
  });

  final FunIcon? icon;
  final String? title;
  final Color? backgroundColor;
  final Widget? content;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(
          color: FunTheme.of(context).neutralVariant95,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(icon != null) Container(
              padding: EdgeInsets.zero,
              child: SizedBox(
                width: 140,
                height: 140,
                child: icon,
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 16),
              TitleMediumText(
                title!,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 8),
            content ?? const SizedBox(),
            if (button != null) ...[
              const SizedBox(height: 16),
              button!,
            ],
          ],
        ),
      ),
    );
  }
}
