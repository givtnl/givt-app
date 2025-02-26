import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_small_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunBubble extends StatelessWidget {
  const FunBubble({required this.child, super.key});

  factory FunBubble.betaCaptain({required String text}) {
    return FunBubble(
      child: Row(
        children: [
          FunAvatar.betaCaptain(),
          const SizedBox(width: 12),
          Flexible(child: BodySmallText(text)),
        ],
      ),
    );
  }

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: FamilyAppTheme.primary40.withValues(alpha: 0.3),
            blurRadius: 9.8,
            offset: const Offset(1, 1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
