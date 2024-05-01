import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/models/family_value.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class FamilyValueContainer extends StatelessWidget {
  const FamilyValueContainer({required this.familyValue, super.key});
  final FamilyValue familyValue;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      borderColor: familyValue.colorCombo.borderColor,
      onTap: () {},
      child: Container(
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: familyValue.colorCombo.textColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
