import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/utils/utils.dart';

/// UK mandate confirmation: copy + tappable Direct Debit Guarantee + Bacs logo.
class SignMandateUkDdFooter extends StatelessWidget {
  const SignMandateUkDdFooter({
    required this.locals,
    super.key,
  });

  final AppLocalizations locals;

  void _openDirectDebitGuarantee(BuildContext context) {
    AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.signMandateDirectDebitGuaranteeOpened,
    );
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (BuildContext sheetContext) => TermsAndConditionsDialog(
        content: locals.bacsDdGuarantee,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = FunTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4,
            children: [
              BodySmallText(
                locals.signMandateUkDdFooterBeforeLink,
                color: colors.primary20,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _openDirectDebitGuarantee(context),
                child: BodySmallText(
                  locals.signMandateUkDdGuaranteeLink,
                  color: colors.primary20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Image.asset(
          'assets/images/direct_debit_logo.png',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
