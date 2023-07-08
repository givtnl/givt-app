import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
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
    final user = (context.read<AuthCubit>().state as AuthSuccess).user;
    _selectedCountry = Country.values.firstWhere(
      (element) => element.countryCode == user.country,
      orElse: () => Country.unknown,
    );
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
      appBar: RegistrationAppBar(
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
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

                      if (!Country.unitedKingdomCodes().contains(
                        _selectedCountry.countryCode,
                      )) {
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
                    onFieldChanged: (value) => setState(() {}),
                    onPaymentChanged: (value) {
                      if (value == 0) {
                        bankAccount.clear();
                        sortCode.clear();
                        if (Country.unitedKingdomCodes()
                            .contains(_selectedCountry.countryCode)) {
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
                      if (!Country.unitedKingdomCodes()
                          .contains(_selectedCountry.countryCode)) {
                        showDialog<void>(
                          context: context,
                          builder: (context) => _buildWarningDialog(
                            message: locals.alertBacsMessage(
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
      height: MediaQuery.of(context).size.height,
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
              backgroundColor: Theme.of(context).colorScheme.tertiary,
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
        MobileNumberFormField(
          phone: _phone,
          selectedCountryPrefix: _selectedCountry.prefix,
          onPhoneChanged: (String value) => setState(() {}),
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
            if (!Util.phoneNumberRegEx.hasMatch(value)) {
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          errorStyle: const TextStyle(
            height: 0,
          ),
        ),
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
