import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/stripe_info_sheet.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/uppercase_text_formatter.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _selectedCountry = Country.fromCode(user.country);
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
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;
    final isUs = _selectedCountry == Country.us;
    final isUk =
        Country.unitedKingdomCodes().contains(_selectedCountry.countryCode);
    return Scaffold(
      appBar: RegistrationAppBar(
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              backgroundColor: AppTheme.givtBlue,
              builder: (_) {
                return _buildPersonalInfoBottomSheet(context);
              },
            ),
            icon: const Icon(Icons.info_rounded),
          ),
        ],
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUs)
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    backgroundColor: AppTheme.givtBlue,
                    builder: (_) => const StripeInfoSheet(),
                  ),
                  icon: const Icon(
                    Icons.info_rounded,
                    size: 20,
                  ),
                  label: Text(locals.moreInformationAboutStripe),
                ),
              )
            else
              const SizedBox(),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: isEnabled ? _onNext : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(
                  _selectedCountry == Country.us
                      ? locals.enterPaymentDetails
                      : locals.next,
                ),
              ),
          ],
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(locals.registerPersonalPage),
                  _buildTextFormField(
                    isVisible: !isUs,
                    hintText: locals.streetAndHouseNumber,
                    controller: _address,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  _buildTextFormField(
                    isVisible: !isUs,
                    hintText: locals.postalCode,
                    controller: _postalCode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      if (!isUk) {
                        return null;
                      }

                      if (!Util.ukPostCodeRegEx.hasMatch(value)) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  _buildTextFormField(
                    isVisible: !isUs,
                    hintText: locals.city,
                    controller: _city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  _buildCountryAndMobileNumber(
                    size,
                    locals,
                    context,
                  ),
                  Visibility(
                    visible: !isUs,
                    child: PaymentSystemTab(
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
                            showDialog<void>(
                              context: context,
                              builder: (context) => _buildWarningDialog(
                                message: locals.alertSepaMessage(
                                  Country.getCountry(
                                    _selectedCountry.countryCode,
                                    locals,
                                  ),
                                ),
                              ),
                            );
                          }
                          setState(() {});
                          return;
                        }
                        if (!isUk) {
                          showDialog<void>(
                            context: context,
                            builder: (context) => _buildWarningDialog(
                              message: locals.alertSepaMessage(
                                Country.getCountry(
                                  _selectedCountry.countryCode,
                                  locals,
                                ),
                              ),
                            ),
                          );
                        }
                        setState(ibanNumber.clear);
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildPersonalInfoBottomSheet(
    BuildContext context,
  ) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            context.l10n.personalInfo,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.informationPersonalData,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: AppTheme.givtBlue,
              builder: (_) => const TermsAndConditionsDialog(
                typeOfTerms: TypeOfTerms.privacyPolicy,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.softenedGivtPurple,
            ),
            child: Text(context.l10n.readPrivacy),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCountryAndMobileNumber(
    Size size,
    AppLocalizations locals,
    BuildContext context, {
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField<Country>(
              validator: (value) {
                if (value == null) {
                  return '';
                }

                return null;
              },
              value: _selectedCountry,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                labelText: locals.country,
                labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                    ),
                errorStyle: const TextStyle(
                  height: 0,
                ),
              ),
              menuMaxHeight: size.height * 0.3,
              items: Country.sortedCountries()
                  .where((element) => element.isUS == _selectedCountry.isUS)
                  .map(
                    (Country country) => DropdownMenuItem(
                      value: country,
                      child: Text(
                        Country.getCountry(country.countryCode, locals),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (Country? newValue) {
                setState(() {
                  _selectedCountry = newValue!;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          MobileNumberFormField(
            phone: _phone,
            selectedCountryPrefix: _selectedCountry.prefix,
            hintText: _selectedCountry != Country.us
                ? locals.phoneNumber
                : locals.mobileNumberUsDigits,
            onPhoneChanged: (String value) => setState(() {}),
            onPrefixChanged: (String selected) {
              setState(() {
                _selectedCountry = Country.sortedCountries().firstWhere(
                  (Country country) => country.countryCode == selected,
                );
              });
            },
            formatter: (_selectedCountry == Country.us)
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]
                : null,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return '';
              }

              if (Country.unitedKingdomCodes()
                  .contains(_selectedCountry.countryCode)) {
                if (!Util.ukPhoneNumberRegEx
                    .hasMatch('${_selectedCountry.prefix}$value')) {
                  return '';
                }
                return null;
              }
              if (Country.us != _selectedCountry &&
                  !Country.unitedKingdomCodes()
                      .contains(_selectedCountry.countryCode)) {
                final prefix = _selectedCountry.prefix.replaceAll('+', '');
                if (!Util.phoneNumberRegEx(prefix).hasMatch('+$prefix$value')) {
                  return '';
                }
              }
              if (Country.us == _selectedCountry) {
                final numericOnly = value.replaceAll(RegExp(r'[^\d]'), '');
                var formatted = '';
                if (numericOnly.length == 10) {
                  final chunkSize = [3, 3, 4];
                  var startIndex = 0;

                  final chunks = chunkSize.map((size) {
                    final chunk =
                        numericOnly.substring(startIndex, startIndex + size);
                    startIndex += size;
                    return chunk;
                  });
                  formatted = chunks.join('-');
                }
                if (!Util.usPhoneNumberRegEx.hasMatch(formatted)) {
                  return '';
                }
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onNext() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    if (_selectedCountry == Country.us) {
      context.read<RegistrationBloc>().add(
            RegistrationPersonalInfoSubmitted(
              address: Util.defaultAdress,
              city: Util.defaultCity,
              postalCode: Util.defaultPostCode,
              country: _selectedCountry.countryCode,
              phoneNumber: '${_selectedCountry.prefix}${_phone.text}',
              iban: Util.defaultIban,
              sortCode: sortCode.text,
              accountNumber: bankAccount.text,
              appLanguage: Localizations.localeOf(context).languageCode,
              countryCode: _selectedCountry.countryCode,
            ),
          );
      return;
    }
    context.read<RegistrationBloc>().add(
          RegistrationPersonalInfoSubmitted(
            address: _address.text,
            city: _city.text,
            postalCode: _postalCode.text,
            country: _selectedCountry.countryCode,
            phoneNumber: '${_selectedCountry.prefix}${_phone.text}',
            iban: ibanNumber.text,
            sortCode: sortCode.text,
            accountNumber: bankAccount.text,
            appLanguage: Localizations.localeOf(context).languageCode,
            countryCode: _selectedCountry.countryCode,
          ),
        );
  }

  bool get isEnabled {
    if (_formKey.currentState == null) return false;
    if (_formKey.currentState!.validate() == false) return false;
    return true;
  }

  Widget _buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool toUpperCase = false,
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: CustomTextFormField(
        controller: controller,
        hintText: hintText,
        inputFormatters: toUpperCase ? [UpperCaseTextFormatter()] : [],
        onChanged: (value) => setState(() {
          _formKey.currentState!.validate();
        }),
        validator: validator,
      ),
    );
  }

  Widget _buildWarningDialog({required String message}) {
    return CupertinoAlertDialog(
      title: Text(context.l10n.important),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.l10n.confirm),
        ),
      ],
    );
  }
}
