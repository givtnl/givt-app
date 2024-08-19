import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/utils/app_theme.dart';

class AcceptPolicyRowUs extends StatelessWidget {
  const AcceptPolicyRowUs({
    required this.onTap,
    required this.checkBoxValue,
    super.key,
  });
  final void Function(bool?)? onTap;
  final bool checkBoxValue;
  @override
  Widget build(BuildContext context) {
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
            side: const BorderSide(
              color: AppTheme.inputFieldBorderEnabled,
              width: 2,
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BodySmallText.primary40(
                      'Givt is permitted to save my data',
                    ),
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 8),
                ),
                const WidgetSpan(
                  child: Icon(
                    FontAwesomeIcons.circleInfo,
                    size: 20,
                    color: AppTheme.primary20,
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