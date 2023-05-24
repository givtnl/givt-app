import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/l10n/l10n.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  const TermsAndConditionsDialog({
    required this.typeOfTerms,
    super.key,
  });

  final TypeOfTerms typeOfTerms;

  @override
  Widget build(BuildContext context) {
    final localName = Platform.localeName;
    final locals = AppLocalizations.of(context);
    String termsAndConditions = locals.termsText;
    String title = locals.fullVersionTitleTerms;
    if (typeOfTerms == TypeOfTerms.privacyPolicy) {
      if (['GB', 'GG', 'JE'].contains(localName)) {
        termsAndConditions = locals.policyTextGB;
      }
      if (localName.contains('US')) {
        termsAndConditions = locals.policyTextUS;
      }
      termsAndConditions = locals.policyText;
      title = locals.policyText;
    }
    if (typeOfTerms == TypeOfTerms.termsAndConditions) {
      if (['GB', 'GG', 'JE'].contains(localName)) {
        termsAndConditions = locals.termsTextGB;
      }
      if (localName.contains('US')) {
        termsAndConditions = locals.termsTextUS;
      }
    }
    if (typeOfTerms == TypeOfTerms.slimPayInfo) {
      title = locals.slimPayInfoDetailTitle;
      termsAndConditions = locals.slimPayInfoDetail;
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              termsAndConditions,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
