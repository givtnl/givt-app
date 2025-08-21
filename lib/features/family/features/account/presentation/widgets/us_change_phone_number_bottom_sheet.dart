import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/registration/widgets/us_mobile_number_form_field.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/util.dart';

class USChangePhoneNumberBottomSheet extends StatefulWidget {
  const USChangePhoneNumberBottomSheet({
    required this.country,
    required this.phoneNumber,
    required this.asyncCubit,
    super.key,
  });

  final String phoneNumber;
  final String country;
  final FunBottomSheetWithAsyncActionCubit asyncCubit;

  @override
  State<USChangePhoneNumberBottomSheet> createState() =>
      _USChangePhoneNumberBottomSheetState();
}

class _USChangePhoneNumberBottomSheetState
    extends State<USChangePhoneNumberBottomSheet> {
  final FamilyAuthRepository _familyAuthRepository =
      getIt<FamilyAuthRepository>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController phone = TextEditingController();
  late Country selectedCountry;

  @override
  void initState() {
    selectedCountry = Country.fromCode(widget.country);
    phone.text = widget.phoneNumber.replaceAll(selectedCountry.prefix, '');
    super.initState();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    if (!Util.usPhoneNumberRegEx.hasMatch(Util.formatPhoneNrUs(value))) {
      return '';
    }

    if (Country.unitedKingdomCodes().contains(selectedCountry.countryCode)) {
      if (!Util.ukPhoneNumberRegEx.hasMatch(value)) {
        return '';
      }
    }

    return null;
  }

  void onPrefixChanged(String selected) {
    setState(() {
      selectedCountry = Country.sortedCountries().firstWhere(
        (Country country) => country.countryCode == selected,
      );
    });
  }

  void onPhoneChanged(String value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: locals.changePhone,
      primaryButton: FunButton(
        isDisabled: !isEnabled,
        onTap: isEnabled
            ? () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                widget.asyncCubit.doAsyncAction(
                  () async {
                    await _familyAuthRepository
                        .updateNumber(selectedCountry.prefix + phone.text);
                  },
                );
              }
            : null,
        text: locals.save,
        analyticsEvent: AmplitudeEvents.editPhoneNumberSaveClicked.toEvent(
          parameters: {
            'country': selectedCountry.countryCode,
            'new_phone': selectedCountry.prefix + phone.text,
            'old_phone': widget.phoneNumber,
            'old_country': widget.country,
          },
        ),
      ),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            MobileNumberFormFieldUs(
              phone: phone,
              onPhoneChanged: onPhoneChanged,
              onPrefixChanged: onPrefixChanged,
              validator: validator,
              hintText: locals.phoneNumber,
              selectedCountryPrefix: selectedCountry.prefix,
            )
          ],
        ),
      ),
    );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    return formKey.currentState!.validate();
  }
}
