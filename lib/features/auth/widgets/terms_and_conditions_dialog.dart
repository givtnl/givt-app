import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
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
    return FutureBuilder(
      future: FlutterSimCountryCode.simCountryCode,
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final localName = Platform.localeName;
        final locals = context.l10n;
        final countryIso = snapshot.data ?? 'NL';

        var termsAndConditions = locals.termsText;
        var title = locals.fullVersionTitleTerms;
        if (typeOfTerms == TypeOfTerms.privacyPolicy) {
          title = locals.privacyTitle;
          termsAndConditions = locals.policyText;
          if (['GB', 'GG', 'JE'].contains(localName)) {
            termsAndConditions = locals.policyTextGB;
          }

          if (countryIso == 'US') {
            termsAndConditions = locals.policyTextUS;
          }
        }
        if (typeOfTerms == TypeOfTerms.termsAndConditions) {
          if (['GB', 'GG', 'JE'].contains(countryIso)) {
            termsAndConditions = locals.termsTextGB;
          }
          if (localName == 'US') {
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  termsAndConditions,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
