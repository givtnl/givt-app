import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/accept_policy_row_us.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class UsSignUpPage extends StatefulWidget {
  const UsSignUpPage({
    super.key,
    this.email = '',
  });

  final String email;

  @override
  State<UsSignUpPage> createState() => _UsSignUpPageState();
}

class _UsSignUpPageState extends State<UsSignUpPage> {
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

    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status == RegistrationStatus.createStripeAccount) {
          context.goNamed(
            FamilyPages.creditCardDetails.name,
            extra: context.read<RegistrationBloc>(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: GenerosityAppBar(
            leading: const GenerosityBackButton(),
            title: 'Enter you details',
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
                  FontAwesomeIcons.question,
                  size: 26,
                  color: AppTheme.primary30,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? _buildLoadingState()
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            _buildSignUpForm(locals, size),
                            const Spacer(),
                            _buildBottomWidgetGroup(locals, size),
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
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.registrationFilledInPersonalInfoSheetFilled,
        eventProperties: {
          'id': context.read<AuthCubit>().state.user.guid,
          'profile_country': _selectedCountry.countryCode,
        },
      ),
    );
    context.read<RegistrationBloc>()
      ..add(
        RegistrationPasswordSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        ),
      )
      ..add(
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.holdOnRegistration),
          const SizedBox(height: 16),
          const CustomCircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildBottomWidgetGroup(
    AppLocalizations locals,
    Size size,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AcceptPolicyRowUs(
            onTap: (value) {
              setState(() {
                _acceptPolicy = value!;
              });
            },
            checkBoxValue: _acceptPolicy,
          ),
          GivtElevatedButton(
            isDisabled: !_isEnabled,
            onTap: _isEnabled ? _register : null,
            text: locals.enterPaymentDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(AppLocalizations locals, Size size) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedTextFormField(
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
            hintText: AppLocalizations.of(context).firstName,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            errorStyle: const TextStyle(
              height: 0,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedTextFormField(
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
            hintText: AppLocalizations.of(context).surname,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            errorStyle: const TextStyle(
              height: 0,
            ),
          ),
          const SizedBox(height: 16),
          // MobileNumberFormField(
          //   phone: _phoneNumberController,
          //   selectedCountryPrefix: _selectedCountry.prefix,
          //   hintText: locals.mobileNumberUsDigits,
          //   onPhoneChanged: (String value) => setState(() {
          //     _formKey.currentState!.validate();
          //   }),
          //   onPrefixChanged: (String selected) {
          //     setState(() {
          //       _selectedCountry = Country.sortedCountries().firstWhere(
          //         (Country country) => country.countryCode == selected,
          //       );
          //     });
          //   },
          //   formatter: [
          //     FilteringTextInputFormatter.digitsOnly,
          //     LengthLimitingTextInputFormatter(10),
          //   ],
          //   validator: (String? value) {
          //     if (value == null || value.isEmpty) {
          //       return '';
          //     }

          //     if (Country.us == _selectedCountry) {
          //       if (!Util.usPhoneNumberRegEx
          //           .hasMatch(Util.formatPhoneNrUs(value))) {
          //         return '';
          //       }
          //     }

          //     return null;
          //   },
          // ),const SizedBox(height: 16),
          OutlinedTextFormField(
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
            errorStyle: const TextStyle(
              height: 0,
            ),
            obscureText: _obscureText,
            textInputAction: TextInputAction.next,
            hintText: AppLocalizations.of(context).password,
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
          const SizedBox(height: 16),
          BodySmallText.primary40(
            locals.passwordRule,
          ),
        ],
      ),
    );
  }
}
