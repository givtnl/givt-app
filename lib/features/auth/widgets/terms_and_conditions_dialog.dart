import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class TermsAndConditionsDialog extends StatefulWidget {
  const TermsAndConditionsDialog({
    required this.typeOfTerms,
    super.key,
  });
  //todo refactor this to use the title and the instead of the [TypeOfTerms]
  final TypeOfTerms typeOfTerms;

  @override
  State<TermsAndConditionsDialog> createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  final _cubit = getIt<EmailSignupCubit>();
  late String countryIso;
  @override
  void initState() {
    super.initState();
    _cubit.init();
    setState(() {
      countryIso = Country.nl.countryCode;
    });
    _getCountry();
  }

  Future<void> _getCountry() async {
    final country = await _cubit.getCountry();
    setState(() {
      countryIso = country.countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final isUs = countryIso == Country.us.countryCode;
    var termsAndConditions = locals.termsText;
    var title = locals.fullVersionTitleTerms;
    if (widget.typeOfTerms == TypeOfTerms.privacyPolicy) {
      title = locals.privacyTitle;
      termsAndConditions = locals.policyText;
      if (Country.unitedKingdomCodes().contains(countryIso)) {
        termsAndConditions = locals.policyTextGb;
      }
      if (isUs) {
        termsAndConditions = locals.policyTextUs;
      }
    }
    if (widget.typeOfTerms == TypeOfTerms.termsAndConditions) {
      if (Country.unitedKingdomCodes().contains(countryIso)) {
        termsAndConditions = locals.termsTextGb;
      }
      if (isUs) {
        termsAndConditions = locals.termsTextUs;
      }
    }
    if (widget.typeOfTerms == TypeOfTerms.slimPayInfo) {
      title = locals.slimPayInfoDetailTitle;
      termsAndConditions = locals.slimPayInfoDetail;
    }
    if (widget.typeOfTerms == TypeOfTerms.bacsInfo) {
      title = locals.bacsAdvanceNoticeTitle;
      termsAndConditions = locals.bacsAdvanceNotice;
    }
    if (widget.typeOfTerms == TypeOfTerms.directDebitGuarantee) {
      title = locals.bacsDdGuaranteeTitle;
      termsAndConditions = locals.bacsDdGuarantee;
    }
    if (widget.typeOfTerms == TypeOfTerms.giftAid) {
      title = locals.giftAidInfoTitle;
      termsAndConditions = locals.giftAidInfoBody;
    }

    return Theme(
      data: const FamilyAppTheme().toThemeData(),
      child: FunBottomSheet(
        title: title,
        titleColor: isUs ? FamilyAppTheme.primary20 : Colors.white,
        content: BodySmallText(
          termsAndConditions,
          color: isUs ? FamilyAppTheme.primary20 : Colors.white,
        ),
        closeAction: () => context.pop(),
      ),
    );
  }
}
