import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/network/country_iso_info.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  const TermsAndConditionsDialog({
    required this.typeOfTerms,
    super.key,
  });
  //todo refactor this to use the title and the instead of the [TypeOfTerms]
  final TypeOfTerms typeOfTerms;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: const FamilyAppTheme().toThemeData(),
      child: FutureBuilder(
        future: getIt<CountryIsoInfo>().checkCountryIso,
        builder: (context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final locals = context.l10n;
          final countryIso = snapshot.data;

          var termsAndConditions = locals.termsText;
          var title = locals.fullVersionTitleTerms;
          if (typeOfTerms == TypeOfTerms.privacyPolicy) {
            title = locals.privacyTitle;
            termsAndConditions = locals.policyText;
            if (Country.unitedKingdomCodes().contains(countryIso)) {
              termsAndConditions = locals.policyTextGb;
            }

            if (countryIso == Country.us.countryCode) {
              termsAndConditions = locals.policyTextUs;
            }
          }
          if (typeOfTerms == TypeOfTerms.termsAndConditions) {
            if (Country.unitedKingdomCodes().contains(countryIso)) {
              termsAndConditions = locals.termsTextGb;
            }
            if (countryIso == Country.us.countryCode) {
              termsAndConditions = locals.termsTextUs;
            }
          }
          if (typeOfTerms == TypeOfTerms.slimPayInfo) {
            title = locals.slimPayInfoDetailTitle;
            termsAndConditions = locals.slimPayInfoDetail;
          }
          if (typeOfTerms == TypeOfTerms.bacsInfo) {
            title = locals.bacsAdvanceNoticeTitle;
            termsAndConditions = locals.bacsAdvanceNotice;
          }
          if (typeOfTerms == TypeOfTerms.directDebitGuarantee) {
            title = locals.bacsDdGuaranteeTitle;
            termsAndConditions = locals.bacsDdGuarantee;
          }
          if (typeOfTerms == TypeOfTerms.giftAid) {
            title = locals.giftAidInfoTitle;
            termsAndConditions = locals.giftAidInfoBody;
          }
          return FunBottomSheet(
            title: title,
            titleColor: Colors.white,
            content: BodySmallText(
              termsAndConditions,
              color: Colors.white,
            ),
            closeAction: () => context.pop(),
          );
        },
      ),
    );
  }
}
