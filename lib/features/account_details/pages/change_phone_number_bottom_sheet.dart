import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_sheet_success.dart';
import 'package:givt_app/features/family/features/registration/widgets/us_mobile_number_form_field.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/util.dart';

class ChangePhoneNumberBottomSheet extends StatefulWidget {
  const ChangePhoneNumberBottomSheet({
    required this.country,
    required this.phoneNumber,
    super.key,
  });

  final String phoneNumber;
  final String country;

  @override
  State<ChangePhoneNumberBottomSheet> createState() =>
      _ChangePhoneNumberBottomSheetState();
}

class _ChangePhoneNumberBottomSheetState
    extends State<ChangePhoneNumberBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phone = TextEditingController();
  late Country selectedCountry;

  @override
  void initState() {
    selectedCountry = Country.fromCode(widget.country);
    phone.text = widget.phoneNumber.replaceAll(selectedCountry.prefix, '');
    super.initState();
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  String? validator(String? value) {
    final cleanedValue = value?.replaceAll(RegExp(r'\s+'), '') ?? '';
    if (cleanedValue.isEmpty) {
      return '';
    }
    final normalizedValue = Util.normalizePhoneNumber(
      country: selectedCountry,
      phoneNumber: cleanedValue,
    );
    if (normalizedValue.isEmpty) {
      return '';
    }
    if (!Util.phoneNumberRegExWithPrefix()
        .hasMatch('${selectedCountry.prefix}$normalizedValue')) {
      return '';
    }

    if (Country.unitedKingdomCodes().contains(selectedCountry.countryCode)) {
      final matchesLocal = Util.ukPhoneNumberRegEx.hasMatch(cleanedValue);
      final matchesInternational = Util.ukPhoneNumberRegEx
          .hasMatch('${selectedCountry.prefix}$normalizedValue');
      if (!matchesLocal && !matchesInternational) {
        return '';
      }
    }

    return null;
  }

  void onPrefixChanged(String selected) {
    setState(() {
      selectedCountry = Country.fromPrefix(
        selected,
        fallback: selectedCountry,
      );
    });
  }

  void onPhoneChanged(String value) {
    setState(() {});
  }

  String get _formattedPhoneNumber => Util.formatPhoneNumberWithPrefix(
        country: selectedCountry,
        phoneNumber: phone.text,
      );

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
      builder: (context, state) {
        final isLoading = state.status == PersonalInfoEditStatus.loading;
        final isSuccess = state.status == PersonalInfoEditStatus.success;

        if (isSuccess) {
          return FunBottomSheet(
            closeAction: () => completePersonalInfoEditSheet(context),
            title: locals.success,
            content: FunIcon.checkmark(),
            primaryButton: FunButton(
              text: locals.buttonDone,
              onTap: () => completePersonalInfoEditSheet(context),
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.editPhoneNumberSaveClicked,
              ),
            ),
          );
        }

        return FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: locals.changePhone,
          content: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
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
          primaryButton: FunButton(
            isDisabled: !isEnabled || isLoading,
            onTap: isEnabled && !isLoading ? _onSave : null,
            text: isLoading ? locals.loadingTitle : locals.save,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.editPhoneNumberSaveClicked,
            ),
          ),
        );
      },
    );
  }

  void _onSave() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.read<PersonalInfoEditBloc>().add(
          PersonalInfoEditPhoneNumber(
            phoneNumber: _formattedPhoneNumber,
          ),
        );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (!formKey.currentState!.validate()) return false;
    return _formattedPhoneNumber != widget.phoneNumber;
  }
}
