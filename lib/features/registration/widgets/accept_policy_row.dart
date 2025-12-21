import 'package:flutter/material.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';

class AcceptPolicyRow extends StatelessWidget {
  const AcceptPolicyRow({
    required this.onTap,
    required this.checkBoxValue,
    super.key,
  });
  final void Function(bool?)? onTap;
  final bool checkBoxValue;
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        builder: (context) => TermsAndConditionsDialog(
          content: locals.policyText,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            semanticLabel: 'acceptPolicyCheckbox',
            value: checkBoxValue,
            onChanged: onTap,
            activeColor: FamilyAppTheme.primary40,
            checkColor: Colors.white,
            side: const BorderSide(
              color: FamilyAppTheme.primary40,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: locals.acceptPolicy,
                    style: const FamilyAppTheme()
                        .toThemeData()
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                          color: FamilyAppTheme.primary20,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.info_rounded,
                        size: 16,
                        color: FamilyAppTheme.primary40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
