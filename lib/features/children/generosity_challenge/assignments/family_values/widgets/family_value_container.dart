import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/app_theme.dart';

class FamilyValueContainer extends StatelessWidget {
  const FamilyValueContainer(
      {required this.familyValue, required this.isSelected, super.key});
  final FamilyValue familyValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      borderColor: familyValue.colorCombo.borderColor,
      isSelected: isSelected,
      onTap: () {
        context.read<FamilyValuesCubit>().selectValue(familyValue);
      },
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: familyValue.colorCombo.textColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Rouna',
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
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}