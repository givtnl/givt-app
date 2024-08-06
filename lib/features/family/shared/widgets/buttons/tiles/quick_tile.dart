import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/features/family/features/profiles/widgets/action_tile.dart';

class QuickTile extends StatelessWidget {
  const QuickTile({
    required this.iconPath,
    super.key,
    this.titleSmall = '',
    this.titleBig = '',
    this.edgeInsets,
    this.isSelected = false,
    this.colorCombo = ColorCombo.primary,
    this.onClick,
  });

  final String titleBig;
  final String titleSmall;
  final String iconPath;
  final EdgeInsets? edgeInsets;
  final bool isSelected;
  final ColorCombo colorCombo;
  final void Function(BuildContext context)? onClick;

  @override
  Widget build(BuildContext context) => Padding(
        padding: edgeInsets ?? EdgeInsets.zero,
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(width: 156, height: 116),
          child: ActionTile(
            onTap: () => onClick?.call(context),
            isSelected: isSelected,
            borderColor: colorCombo.borderColor,
            backgroundColor: colorCombo.backgroundColor,
            textColor: colorCombo.textColor,
            assetSize: 32,
            iconPath: iconPath,
            titleBig: titleBig,
            titleSmall: titleSmall,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      );
}
