import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/acceptPolicyRow.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/color_schemes.g.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    this.email = '',
  });

  final String email;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;

  bool _acceptPolicy = false;
  bool isLoading = false;
  bool _obscureText = true;
  Country _selectedCountry = Country.sortedCountries().first;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    final user = context.read<AuthCubit>().state.user;
    _selectedCountry = Country.fromCode(user.country);
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final isUS = _selectedCountry == Country.us;

    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (!(_selectedCountry == Country.us) &&
            state.status == RegistrationStatus.personalInfo) {
          context.goNamed(
            FamilyPages.personalInfo.name,
            extra: context.read<RegistrationBloc>(),
          );
        }

        if (state.status == RegistrationStatus.sepaMandateExplanation) {
          context.goNamed(
            Pages.sepaMandateExplanation.name,
            extra: context.read<RegistrationBloc>(),
          );
        }

        if (state.status ==
            RegistrationStatus.bacsDirectDebitMandateExplanation) {
          context.goNamed(
            Pages.bacsMandateExplanation.name,
            extra: context.read<RegistrationBloc>(),
          );
        }
        if (state.status == RegistrationStatus.createStripeAccount) {
          context.goNamed(
            FamilyPages.creditCardDetails.name,
            extra: context.read<RegistrationBloc>(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: RegistrationAppBar(
            title: isUS
                ? Text(
                    locals.signUpPageTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                  )
                : null,
            actions: [
              IconButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: AppTheme.givtBlue,
                  builder: (_) => const FAQBottomSheet(),
                ),
                icon: const Icon(
                  Icons.question_mark_outlined,
                  size: 26,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? _buildLoadingState(isUS)
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            _buildSignUpForm(locals, size, isUS),
                            const Spacer(),
                            _buildBottomWidgetGroup(locals, size, isUS),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Future<void> _register() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate() == false &&
        _selectedCountry != Country.us) {
      setState(() {
        isLoading = false;
      });
    }
    context.read<RegistrationBloc>().add(
          RegistrationPasswordSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
          ),
        );
    if (_selectedCountry == Country.us) {
      context.read<RegistrationBloc>().add(
            RegistrationPersonalInfoSubmitted(
              address: Util.defaultAdress,
              city: Util.defaultCity,
              postalCode: Util.defaultPostCode,
              country: _selectedCountry.countryCode,
              phoneNumber: _phoneNumberController.text,
              iban: Util.defaultIban,
              sortCode: Util.empty,
              accountNumber: Util.empty,
              appLanguage: Localizations.localeOf(context).languageCode,
              countryCode: _selectedCountry.countryCode,
            ),
          );
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  bool get _isEnabled {
    if (isLoading) return false;
    if (_formKey.currentState == null) return false;
    if (_acceptPolicy == true && _formKey.currentState!.validate()) return true;
    return false;
  }

  Widget _buildLoadingState(bool isUS) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isUS) Text(context.l10n.holdOnRegistration),
          if (isUS) const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildBottomWidgetGroup(
    AppLocalizations locals,
    Size size,
    bool isUS,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AcceptPolicyRow(
            onTap: (value) {
              setState(() {
                _acceptPolicy = value!;
              });
            },
            checkBoxValue: _acceptPolicy,
          ),
          ElevatedButton(
            onPressed: _isEnabled ? _register : null,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Colors.grey,
            ),
            child: Text(
              isUS ? locals.enterPaymentDetails : locals.next,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(AppLocalizations locals, Size size, bool isUS) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (!Util.nameFieldsRegEx.hasMatch(value)) {
                return '';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onChanged: (value) => setState(() {
              _formKey.currentState!.validate();
            }),
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).firstName,
              errorStyle: const TextStyle(
                height: 0,
              ),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            onChanged: (value) => setState(() {
              _formKey.currentState!.validate();
            }),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (!Util.nameFieldsRegEx.hasMatch(value)) {
                return '';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).surname,
              errorStyle: const TextStyle(
                height: 0,
              ),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
          ),
          // Height 6 because of the 10px padding in MobileNumberFormField
          const SizedBox(height: 6),
          if (_selectedCountry == Country.us)
            MobileNumberFormField(
              phone: _phoneNumberController,
              selectedCountryPrefix: _selectedCountry.prefix,
              hintText: locals.mobileNumberUsDigits,
              onPhoneChanged: (String value) => setState(() {
                _formKey.currentState!.validate();
              }),
              onPrefixChanged: (String selected) {
                setState(() {
                  _selectedCountry = Country.sortedCountries().firstWhere(
                    (Country country) => country.countryCode == selected,
                  );
                });
              },
              formatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '';
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
          Visibility(
            visible: !isUS,
            child: const SizedBox(height: 16),
          ),
          Visibility(
            visible: !isUS,
            child: TextFormField(
              enabled: widget.email.isEmpty,
              readOnly: widget.email.isNotEmpty,
              controller: _emailController,
              onChanged: (value) => setState(() {
                _formKey.currentState!.validate();
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.invalidEmail;
                }
                if (!Util.emailRegEx.hasMatch(value)) {
                  return context.l10n.invalidEmail;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: widget.email.isNotEmpty
                        ? Colors.grey
                        : lightColorScheme.primary,
                  ),
              decoration: InputDecoration(
                hintText: context.l10n.email,
                errorStyle: const TextStyle(
                  height: 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            onChanged: (value) => setState(() {
              _formKey.currentState!.validate();
            }),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (value.length < 7) {
                return '';
              }
              if (value.contains(RegExp('[0-9]')) == false) {
                return '';
              }
              if (value.contains(RegExp('[A-Z]')) == false) {
                return '';
              }

              return null;
            },
            obscureText: _obscureText,
            textInputAction: TextInputAction.next,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).password,
              errorStyle: const TextStyle(
                height: 0,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            locals.passwordRule,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
