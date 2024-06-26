import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class CustomIconBorderButton extends StatelessWidget {
  const CustomIconBorderButton(
      {required this.onTap, required this.child, super.key,});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      onTap: onTap,
      borderColor: ColorCombo.primary.borderColor,
      baseBorderSize: 4,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: child,
      ),
    );
  }
}
