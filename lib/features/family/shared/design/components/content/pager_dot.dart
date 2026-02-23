import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';

class PagerDot extends StatelessWidget {
  const PagerDot({required this.isSelected, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? FunTheme.of(context).primary40
            : Colors.black.withValues(alpha: 0.1),
      ),
    );
  }
}
