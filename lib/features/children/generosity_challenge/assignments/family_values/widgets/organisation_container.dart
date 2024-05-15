import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/organisation_header.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class OrganisationContainer extends StatelessWidget {
  const OrganisationContainer({required this.familyValue, super.key});

  final FamilyValue familyValue;

  @override
  Widget build(BuildContext context) {
    Image image = Image.network(
      familyValue.orgImagePath,
      fit: BoxFit.cover,
    );

    precacheImage(image.image, context);
    return ActionContainer(
      onTap: () {},
      borderColor: ColorCombo.primary.borderColor,
      baseBorderSize: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Column(
          children: [
            OrganisationHeader(
              value: familyValue,
            ),
            Container(
              height: 168,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: image,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                familyValue.organisation.organisationName!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorCombo.primary.textColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
