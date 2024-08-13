import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/profiles/widgets/action_tile.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';

class InterestCard extends StatelessWidget {
  const InterestCard({
    required this.interest,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  final Tag interest;
  final void Function() onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ActionTile(
      titleSmall: interest.displayText,
      iconPath: interest.pictureUrl,
      onTap: onPressed,
      isSelected: isSelected,
      borderColor: interest.area.borderColor,
      backgroundColor: interest.area.backgroundColor,
      textColor: interest.area.textColor,
    );
  }
}
