import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/fun_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/fun_dialog.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/models/fun_dialog_uimodel.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/shared/widgets/uppercase_text_formatter.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:iban/iban.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({
    super.key,
  });

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _postalCode = TextEditingController();
  final _phone = TextEditingController();
  final bankAccount = TextEditingController();
  final sortCode = TextEditingController();
  final ibanNumber = TextEditingController();
  Country _selectedCountry = Country.sortedCountries().first;
  Country _selectedPhoneCountry = Country.sortedCountries().first;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _selectedCountry = Country.fromCode(user.country);
    _selectedPhoneCountry = _selectedCountry;
  }

  @override
  void dispose() {
    super.dispose();
    _address.dispose();
    _city.dispose();
    _postalCode.dispose();
    _phone.dispose();
    bankAccount.dispose();
    sortCode.dispose();
    ibanNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final isUk = Country.unitedKingdomCodes().contains(
      _selectedCountry.countryCode,
    );
    return FunScaffold(
      appBar: FunTopAppBar.white(
        title: locals.personalInfo,
        actions: [
          IconButton(
            onPressed: () => FunBottomSheet(
              closeAction: () => context.pop(),
              title: locals.personalInfo,
              content: BodyMediumText(
                locals.informationPersonalData,
                textAlign: TextAlign.center,
              ),
              primaryButton: FunButton(
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  builder: (_) => TermsAndConditionsDialog(
                    content: locals.policyText,
                  ),
                ),
                text: locals.readPrivacy,
                analyticsEvent: AmplitudeEvents.infoGivingAllowanceClicked
                    .toEvent(),
              ),
            ).show(context),
            icon: const Icon(Icons.info_rounded),
          ),
        ],
      ),
      floatingActionButton: FunButton(
        onTap: isEnabled ? _onNext : null,
        isDisabled: !isEnabled,
        isLoading: isLoading,
        text: _selectedCountry == Country.us
            ? locals.enterPaymentDetails
            : locals.next,
        analyticsEvent: AmplitudeEvents.continueClicked.toEvent(),
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status == RegistrationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(locals.registrationErrorTitle),
              ),
            );
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        _buildTextFormField(
                          hintText: locals.streetAndHouseNumber,
                          controller: _address,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          autofillHints: const [
                            AutofillHints.fullStreetAddress,
                          ],
                          keyboardType: TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          hintText: locals.postalCode,
                          controller: _postalCode,
                          toUpperCase: isUk,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            if (!isUk) {
                              return null;
                            }

                            final formattedPostCode = Util.formatUkPostCode(
                              value,
                            );
                            if (formattedPostCode == null) {
                              return '';
                            }
                            if (formattedPostCode != _postalCode.text) {
                              _postalCode.text = formattedPostCode;
                            }
                            return null;
                          },
                          autofillHints: const [AutofillHints.postalCode],
                          keyboardType: TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildTextFormField(
                          hintText: locals.city,
                          controller: _city,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          autofillHints: const [AutofillHints.addressCity],
                          keyboardType: TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildCountryAndMobileNumber(
                          locals,
                          context,
                        ),
                        // const Spacer(),
                        const SizedBox(height: 32),
                        PaymentSystemTab(
                          isUK: isUk,
                          bankAccount: bankAccount,
                          ibanNumber: ibanNumber,
                          sortCode: sortCode,
                          onFieldChanged: (value) => setState(() {}),
                          onPaymentChanged: (value) {
                            if (value == 0) {
                              bankAccount.clear();
                              sortCode.clear();
                              if (isUk) {
                                _showWarningDialog(
                                  message: locals.alertSepaMessage(
                                    Country.getCountry(
                                      _selectedCountry.countryCode,
                                      locals,
                                    ),
                                  ),
                                );
                              }
                              setState(() {});
                              return;
                            }
                            if (!isUk) {
                              _showWarningDialog(
                                message: locals.alertSepaMessage(
                                  Country.getCountry(
                                    _selectedCountry.countryCode,
                                    locals,
                                  ),
                                ),
                              );
                            }
                            setState(ibanNumber.clear);
                          },
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCountryAndMobileNumber(
    AppLocalizations locals,
    BuildContext context, {
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          FunInputDropdown<Country>(
            value: _selectedCountry,
            onChanged: (Country? newValue) {
              if (newValue == null) {
                return;
              }
              setState(() {
                _selectedCountry = newValue;
                _selectedPhoneCountry = newValue;
              });
            },
            items: Country.sortedCountries()
                .where((element) => element.isUS == _selectedCountry.isUS)
                .toList(),
            itemBuilder: (context, country) => Text(
              Country.getCountry(country.countryCode, locals),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 8),
          MobileNumberFormField(
            phone: _phone,
            selectedCountryPrefix: _selectedPhoneCountry.prefix,
            hintText: _selectedPhoneCountry != Country.us
                ? locals.phoneNumber
                : locals.mobileNumberUsDigits,
            onPhoneChanged: (String value) => setState(() {}),
            onPrefixChanged: (String selected) {
              setState(() {
                _selectedPhoneCountry = Country.fromPrefix(
                  selected,
                  fallback: _selectedPhoneCountry,
                );
              });
            },
            formatter: (_selectedPhoneCountry == Country.us)
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]
                : null,
            validator: (String? value) {
              final cleanedValue = value?.replaceAll(RegExp(r'\s+'), '') ?? '';
              if (cleanedValue.isEmpty) {
                return '';
              }

              if (Country.unitedKingdomCodes().contains(
                _selectedPhoneCountry.countryCode,
              )) {
                final normalizedValue = Util.normalizePhoneNumber(
                  country: _selectedPhoneCountry,
                  phoneNumber: cleanedValue,
                );
                if (normalizedValue.isEmpty) {
                  return '';
                }
                final withPrefix =
                    '${_selectedPhoneCountry.prefix}$normalizedValue';
                final matchesLocal = Util.ukPhoneNumberRegEx.hasMatch(
                  cleanedValue,
                );
                final matchesInternational = Util.ukPhoneNumberRegEx.hasMatch(
                  withPrefix,
                );
                if (!matchesLocal && !matchesInternational) {
                  return '';
                }
                return null;
              }

              if (Country.us == _selectedPhoneCountry) {
                if (!Util.usPhoneNumberRegEx.hasMatch(
                  Util.formatPhoneNrUs(cleanedValue),
                )) {
                  return '';
                }
                return null;
              }

              final prefix = _selectedPhoneCountry.prefix.replaceAll('+', '');
              final normalizedValue = Util.normalizePhoneNumber(
                country: _selectedPhoneCountry,
                phoneNumber: cleanedValue,
              );
              if (normalizedValue.isEmpty) {
                return '';
              }
              if (!Util.phoneNumberRegEx(
                prefix,
              ).hasMatch('+$prefix$normalizedValue')) {
                return '';
              }

              return null;
            },
            autofillHints: const [AutofillHints.telephoneNumber],
          ),
        ],
      ),
    );
  }

  Future<void> _onNext() async {
    TextInput.finishAutofillContext();
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    context.read<RegistrationBloc>().add(
      RegistrationPersonalInfoSubmitted(
        address: _address.text,
        city: _city.text,
        postalCode: _postalCode.text,
        country: _selectedCountry.countryCode,
        phoneNumber: Util.formatPhoneNumberWithPrefix(
          country: _selectedPhoneCountry,
          phoneNumber: _phone.text,
        ),
        iban: ibanNumber.text,
        sortCode: sortCode.text,
        accountNumber: bankAccount.text,
        appLanguage: Localizations.localeOf(context).languageCode,
        countryCode: _selectedCountry.countryCode,
      ),
    );
  }

  bool get isEnabled {
    if (_address.text.isEmpty) return false;
    if (_city.text.isEmpty) return false;
    if (_postalCode.text.isEmpty) return false;

    final isUk = Country.unitedKingdomCodes().contains(
      _selectedCountry.countryCode,
    );
    if (isUk && Util.formatUkPostCode(_postalCode.text) == null) {
      return false;
    }

    final phone = _phone.text.replaceAll(RegExp(r'\s+'), '');
    if (phone.isEmpty) return false;

    if (Country.unitedKingdomCodes().contains(
      _selectedPhoneCountry.countryCode,
    )) {
      final normalizedValue = Util.normalizePhoneNumber(
        country: _selectedPhoneCountry,
        phoneNumber: phone,
      );
      if (normalizedValue.isEmpty) return false;
      final withPrefix = '${_selectedPhoneCountry.prefix}$normalizedValue';
      final matchesLocal = Util.ukPhoneNumberRegEx.hasMatch(phone);
      final matchesInternational = Util.ukPhoneNumberRegEx.hasMatch(withPrefix);
      if (!matchesLocal && !matchesInternational) return false;
    } else if (Country.us == _selectedPhoneCountry) {
      if (!Util.usPhoneNumberRegEx.hasMatch(Util.formatPhoneNrUs(phone))) {
        return false;
      }
    } else {
      final prefix = _selectedPhoneCountry.prefix.replaceAll('+', '');
      final normalizedValue = Util.normalizePhoneNumber(
        country: _selectedPhoneCountry,
        phoneNumber: phone,
      );
      if (normalizedValue.isEmpty) return false;
      if (!Util.phoneNumberRegEx(prefix).hasMatch('+$prefix$normalizedValue')) {
        return false;
      }
    }

    if (isUk) {
      if (sortCode.text.isEmpty ||
          !Util.ukSortCodeRegEx.hasMatch(sortCode.text)) {
        return false;
      }
      if (bankAccount.text.isEmpty || bankAccount.text.length != 8) {
        return false;
      }
    } else {
      if (ibanNumber.text.isEmpty || !isValid(ibanNumber.text)) return false;
    }

    return true;
  }

  Widget _buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool toUpperCase = false,
    bool isVisible = true,
    List<String>? autofillHints,
    TextInputType? keyboardType,
  }) {
    return Visibility(
      visible: isVisible,
      child: OutlinedTextFormField(
        controller: controller,
        hintText: hintText,
        inputFormatters: toUpperCase ? [UpperCaseTextFormatter()] : [],
        onChanged: (value) => setState(() {}),
        validator: validator,
        autofillHints: autofillHints ?? const [],
        keyboardType: keyboardType,
        errorStyle: const TextStyle(
          height: 0.01,
        ),
      ),
    );
  }

  void _showWarningDialog({required String message}) {
    FunDialog.show(
      context,
      uiModel: FunDialogUIModel(
        title: context.l10n.important,
        description: message,
        primaryButtonText: context.l10n.confirm,
      ),
    );
  }
}
