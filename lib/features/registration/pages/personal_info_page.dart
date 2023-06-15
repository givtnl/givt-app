import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/util.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const PersonalInfoPage(),
    );
  }

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
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return Scaffold(
      appBar: const RegistrationAppBar(),
      bottomSheet: Container(
        margin: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: isEnabled ? _onNext : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(
                  locals.next,
                ),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(locals.registerPersonalPage),
                _buildTextFormField(
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
                  hintText: locals.postalCode,
                  controller: _postalCode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }

                    if (_selectedCountry != Country.gg ||
                        _selectedCountry != Country.gb ||
                        _selectedCountry != Country.je) {
                      return null;
                    }

                    if (!Util.ukPostCodeRegEx.hasMatch(value)) {
                      return '';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  hintText: locals.city,
                  controller: _city,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                _buildCountryAndMobileNumber(size, locals, context),
                PaymentSystemTab(
                  bankAccount: bankAccount,
                  ibanNumber: ibanNumber,
                  sortCode: sortCode,
                  onPaymentChanged: (value) {
                    if (value == 0) {
                      bankAccount.clear();
                      sortCode.clear();
                      if (_selectedCountry == Country.gg ||
                          _selectedCountry == Country.gb ||
                          _selectedCountry == Country.je) {
                        showDialog<void>(
                          context: context,
                          builder: (context) => _buildWarningDialog(
                            message: locals.alertSEPAMessage(
                              getCountry(_selectedCountry.countryCode, locals),
                            ),
                          ),
                        );
                      }
                      return;
                    }
                    if (_selectedCountry != Country.gg ||
                        _selectedCountry != Country.gb ||
                        _selectedCountry != Country.je) {
                      showDialog<void>(
                        context: context,
                        builder: (context) => _buildWarningDialog(
                          message: locals.alertBACSMessage(
                            getCountry(_selectedCountry.countryCode, locals),
                          ),
                        ),
                      );
                    }
                    ibanNumber.clear();
                  },
                ),
                SizedBox(
                  height: size.height * 0.2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountryAndMobileNumber(
    Size size,
    AppLocalizations locals,
    BuildContext context,
  ) {
    return Column(
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
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              errorStyle: TextStyle(
                height: 0,
              ),
            ),
            menuMaxHeight: size.height * 0.3,
            items: Country.sortedCountries()
                .map(
                  (Country country) => DropdownMenuItem(
                    value: country,
                    child: Text(
                      getCountry(country.countryCode, locals),
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
        MobileNumberFormField(
          phone: _phone,
          selectedCountryPrefix: _selectedCountry.prefix,
          onPrefixChanged: (String selected) {
            setState(() {
              _selectedCountry = Country.sortedCountries().firstWhere(
                (Country country) => country.countryCode == selected,
              );
            });
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            if (_selectedCountry == Country.gg ||
                _selectedCountry == Country.gb ||
                _selectedCountry == Country.je) {
              if (!Util.ukPhoneNumberRegEx.hasMatch(value)) {
                return '';
              }
            }

            return null;
          },
        ),
      ],
    );
  }

  Future<void> _onNext() async {
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
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: (value) => setState(() {
          _formKey.currentState!.validate();
        }),
        textInputAction: TextInputAction.next,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          label: Text(
            hintText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          errorStyle: const TextStyle(
            height: 0,
          ),
        ),
      ),
    );
  }

  String getCountry(String countryCode, AppLocalizations locals) {
    switch (countryCode) {
      case 'JE':
        return locals.jersey;
      case 'GG':
        return locals.guernsey;
      case 'AD':
        return locals.countryStringAD;
      case 'GB':
        return locals.countryStringGB;
      case 'DE':
        return locals.countryStringDE;
      case 'FR':
        return locals.countryStringFR;
      case 'IT':
        return locals.countryStringIT;
      case 'ES':
        return locals.countryStringES;
      case 'NL':
        return locals.countryStringNL;
      case 'BE':
        return locals.countryStringBE;
      case 'AT':
        return locals.countryStringAT;
      case 'PT':
        return locals.countryStringPT;
      case 'IE':
        return locals.countryStringIE;
      case 'FI':
        return locals.countryStringFI;
      case 'LU':
        return locals.countryStringLU;
      case 'SI':
        return locals.countryStringSI;
      case 'SK':
        return locals.countryStringSK;
      case 'EE':
        return locals.countryStringEE;
      case 'LV':
        return locals.countryStringLV;
      case 'LT':
        return locals.countryStringLT;
      case 'GR':
        return locals.countryStringGR;
      case 'CY':
        return locals.countryStringCY;
      case 'MT':
        return locals.countryStringMT;
      default:
        return '';
    }
  }

  Widget _buildWarningDialog({required String message}) {
    return CupertinoAlertDialog(
      title: Text(context.l10n.important),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.confirm),
        ),
      ],
    );
  }
}
