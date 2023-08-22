import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class StripeInfoSheet extends StatelessWidget {
  const StripeInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locals.moreInformationAboutStripeParagraphOne,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            locals.moreInformationAboutStripeParagraphTwo,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: AppTheme.givtBlue,
              builder: (_) => const TermsAndConditionsDialog(
                typeOfTerms: TypeOfTerms.privacyPolicy,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.softenedGivtPurple,
            ),
            child: Text(context.l10n.readPrivacy),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
