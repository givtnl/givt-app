import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class FunCard extends StatelessWidget {
  const FunCard({
    required this.title,
    required this.content,
    required this.button,
    required this.icon,
    super.key,
  });

  final FunIcon icon;
  final String title;
  final Widget content;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: FamilyAppTheme.neutralVariant95,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.zero,
              child: SizedBox(
                width: 140,
                height: 140,
                child: icon,
              ),
            ),
            const SizedBox(height: 16),
            TitleMediumText(
              title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            content,
            if (button != null) const SizedBox(height: 16),
            if (button != null) button!,
          ],
        ),
      ),
    );
  }
}
