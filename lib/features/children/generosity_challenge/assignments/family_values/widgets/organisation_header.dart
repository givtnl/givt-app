import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class OrganisationHeader extends StatelessWidget {
  const OrganisationHeader({
    required this.value,
    super.key,
  });
  final FamilyValue value;
  @override
  Widget build(BuildContext context) {
    final theme = FamilyAppTheme().toThemeData();
    return Container(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: value.interestList
                  .map(
                    (tag) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: value.colorCombo.accentColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 16,
                          right: 8,
                        ),
                        child: Text(
                          tag.displayText,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: value.colorCombo.textColor,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              constraints: BoxConstraints(
                maxHeight: value.interestList.length * 25.0,
              ),
              child: Image.network(
                value.organisation.organisationLogoLink!,
                alignment: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
