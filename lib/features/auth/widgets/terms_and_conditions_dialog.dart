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
    required this.content,
    this.isDarkBackground = false,
    this.overrideCountryIso,
    super.key,
  });

  final String content;
  final bool isDarkBackground;
  final String? overrideCountryIso;

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
      countryIso = widget.overrideCountryIso ?? Country.nl.countryCode;
    });
    _getCountry();
  }

  Future<void> _getCountry() async {
    final country = _cubit.currentCountry;
    setState(() {
      countryIso = country?.countryCode ??
          widget.overrideCountryIso ??
          Country.nl.countryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    var termsAndConditions = widget.content;
    var title = locals.fullVersionTitleTerms;
    if (widget.content == locals.termsText) {
      if (Country.unitedKingdomCodes().contains(countryIso)) {
        termsAndConditions = locals.termsTextGb;
      }
      if (countryIso == Country.us.countryCode) {
        termsAndConditions = locals.termsTextUs;
      }
    }
    if (widget.content == locals.policyText) {
      title = locals.privacyTitle;
      termsAndConditions = locals.policyText;
      if (Country.unitedKingdomCodes().contains(countryIso)) {
        termsAndConditions = locals.policyTextGb;
      }
      if (countryIso == Country.us.countryCode) {
        termsAndConditions = locals.policyTextUs;
      }
    }

    if (widget.content == locals.slimPayInfoDetail) {
      title = locals.slimPayInfoDetailTitle;
    }
    if (widget.content == locals.bacsAdvanceNotice) {
      title = locals.bacsAdvanceNoticeTitle;
    }
    if (widget.content == locals.bacsDdGuarantee) {
      title = locals.bacsDdGuaranteeTitle;
    }
    if (widget.content == locals.giftAidInfoBody) {
      title = locals.giftAidInfoTitle;
    }

    return FunBottomSheet(
      title: title,
      titleColor:
          widget.isDarkBackground ? Colors.white : FamilyAppTheme.primary20,
      content: BodySmallText(
        termsAndConditions,
        color:
            widget.isDarkBackground ? Colors.white : FamilyAppTheme.primary20,
      ),
      closeAction: () => context.pop(),
    );
  }
}
