import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
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
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BottomSheetLayout(
      title: Text(
        locals.changePhone,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      child: BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                MobileNumberFormField(
                  phone: phone,
                  hintText: selectedCountry != Country.us
                      ? locals.phoneNumber
                      : locals.mobileNumberUsDigits,
                  selectedCountryPrefix: selectedCountry.prefix,
                  onPhoneChanged: (String value) => setState(() {}),
                  onPrefixChanged: (String selected) {
                    setState(() {
                      selectedCountry = Country.sortedCountries().firstWhere(
                        (Country country) => country.countryCode == selected,
                      );
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!Util.phoneNumberRegExWithPrefix()
                        .hasMatch('${selectedCountry.prefix}$value')) {
                      return '';
                    }

                    if (Country.unitedKingdomCodes()
                        .contains(selectedCountry.countryCode)) {
                      if (!Util.ukPhoneNumberRegEx.hasMatch(value)) {
                        return '';
                      }
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Expanded(child: Container()),
                if (state.status == PersonalInfoEditStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            context.read<PersonalInfoEditBloc>().add(
                                  PersonalInfoEditPhoneNumber(
                                    phoneNumber:
                                        selectedCountry.prefix + phone.text,
                                  ),
                                );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      locals.save,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    return formKey.currentState!.validate();
  }
}
