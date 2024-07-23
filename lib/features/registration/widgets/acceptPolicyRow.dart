import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

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
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: AppTheme.givtPurple,
        builder: (_) => const TermsAndConditionsDialog(
          typeOfTerms: TypeOfTerms.privacyPolicy,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: checkBoxValue,
            onChanged: onTap,
          ),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      locals.acceptPolicy,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 4),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.info_rounded,
                    size: 16,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
