import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/app_theme.dart';

class FamilyValueContainer extends StatelessWidget {
  const FamilyValueContainer({
    required this.familyValue,
    required this.isSelected,
    this.isPressed = false,
    super.key,
  });
  final FamilyValue familyValue;
  final bool isSelected;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FamilyAppTheme().toThemeData();
    return ActionContainer(
      borderColor: familyValue.colorCombo.borderColor,
      isSelected: isSelected,
      onTap: isPressed
          ? () {}
          : () {
              context.read<FamilyValuesCubit>().selectValue(familyValue);
            },
      isPressedDown: isPressed,
      child: Stack(
        children: [
          Container(
            color: familyValue.colorCombo.backgroundColor,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
            width: double.maxFinite,
            child: Column(
              children: [
                SvgPicture.network(
                  familyValue.imagePath,
                  width: 140,
                  height: 140,
                ),
                Text(
                  familyValue.displayText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: familyValue.colorCombo.textColor,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.primary70,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
