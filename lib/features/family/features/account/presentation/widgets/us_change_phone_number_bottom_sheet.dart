import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/registration/widgets/us_mobile_number_form_field.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/util.dart';

class UsChangePhoneNumberBottomSheet extends StatefulWidget {
  const UsChangePhoneNumberBottomSheet({
    required this.country,
    required this.phoneNumber,
    required this.asyncCubit,
    super.key,
  });

  final String phoneNumber;
  final String country;
  final FunBottomSheetWithAsyncActionCubit asyncCubit;

  @override
  State<UsChangePhoneNumberBottomSheet> createState() =>
      _UsChangePhoneNumberBottomSheetState();
}

class _UsChangePhoneNumberBottomSheetState
    extends State<UsChangePhoneNumberBottomSheet> {
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
    if (!Util.phoneNumberRegExWithPrefix()
        .hasMatch('${selectedCountry.prefix}$value')) {
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
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.editPhoneNumberClicked,
          parameters: {
            'country': selectedCountry.countryCode,
            'phone': selectedCountry.prefix + phone.text,
          },
        ),
      ),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            if (selectedCountry == Country.us)
              MobileNumberFormFieldUs(
                phone: phone,
                onPhoneChanged: onPhoneChanged,
                onPrefixChanged: onPrefixChanged,
                validator: validator,
                hintText: locals.phoneNumber,
                selectedCountryPrefix: selectedCountry.prefix,
              )
            else
              MobileNumberFormField(
                phone: phone,
                hintText: locals.phoneNumber,
                selectedCountryPrefix: selectedCountry.prefix,
                onPhoneChanged: onPhoneChanged,
                onPrefixChanged: onPrefixChanged,
                validator: validator,
              ),
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
