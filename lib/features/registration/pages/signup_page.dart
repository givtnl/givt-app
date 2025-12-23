import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/accept_policy_row.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/fun_faq_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/analytics_helper.dart';
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
    final user = context.read<AuthCubit>().state.user;
    _selectedCountry = Country.fromCode(user.country);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);

    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state.status == RegistrationStatus.personalInfo) {
          context.goNamed(
            Pages.personalInfo.name,
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
      },
      builder: (context, state) {
        return FunScaffold(
          appBar: FunTopAppBar.white(
            title: locals.personalInfo,
            actions: [
              IconButton(
                onPressed: () => const FunFAQBottomSheet().show(context),
                icon: const Icon(
                  Icons.question_mark_outlined,
                  size: 26,
                ),
              ),
            ],
          ),
          floatingActionButton: FunButton(
            onTap: _isEnabled ? _register : null,
            isDisabled: !_isEnabled,
            isLoading: isLoading,
            text: locals.next,
            analyticsEvent: AnalyticsEventName.continueClicked.toEvent(),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        _buildSignUpForm(locals),
                        const Spacer(),
                        const SizedBox(height: 16),
                        AcceptPolicyRow(
                          onTap: (value) {
                            setState(() {
                              _acceptPolicy = value!;
                            });
                          },
                          checkBoxValue: _acceptPolicy,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _register() async {
    TextInput.finishAutofillContext();
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate() == false &&
        _selectedCountry != Country.us) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.registrationFilledInPersonalInfoSheetFilled,
        eventProperties: {
          'id': context.read<AuthCubit>().state.user.guid,
          'profile_country': _selectedCountry.countryCode,
        },
      ),
    );
    context.read<RegistrationBloc>().add(
      RegistrationPasswordSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  bool get _isEnabled {
    if (isLoading) return false;
    if (_acceptPolicy != true) return false;

    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (firstName.isEmpty || !Util.nameFieldsRegEx.hasMatch(firstName)) {
      return false;
    }
    if (lastName.isEmpty || !Util.nameFieldsRegEx.hasMatch(lastName)) {
      return false;
    }
    if (email.isEmpty || !Util.emailRegEx.hasMatch(email)) {
      return false;
    }
    if (password.isEmpty ||
        password.length < 7 ||
        !password.contains(RegExp('[0-9]')) ||
        !password.contains(RegExp('[A-Z]'))) {
      return false;
    }

    return true;
  }

  Widget _buildSignUpForm(AppLocalizations locals) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
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
              onChanged: (value) => setState(() {}),
              autofillHints: const [AutofillHints.givenName],
              hintText: locals.firstName,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              errorStyle: const TextStyle(
                height: 0.01,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedTextFormField(
              controller: _lastNameController,
              onChanged: (value) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                if (!Util.nameFieldsRegEx.hasMatch(value)) {
                  return '';
                }
                return null;
              },
              autofillHints: const [AutofillHints.familyName],
              hintText: locals.surname,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              errorStyle: const TextStyle(
                height: 0.01,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedTextFormField(
              enabled: widget.email.isEmpty,
              readOnly: widget.email.isNotEmpty,
              controller: _emailController,
              onChanged: (value) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.invalidEmail;
                }
                if (!Util.emailRegEx.hasMatch(value)) {
                  return context.l10n.invalidEmail;
                }
                return null;
              },
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username,
              ],
              hintText: context.l10n.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            OutlinedTextFormField(
              controller: _passwordController,
              scrollPadding: const EdgeInsets.only(bottom: 150),
              onChanged: (value) => setState(() {}),
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
              autofillHints: const [
                AutofillHints.newPassword,
              ],
              obscureText: _obscureText,
              hintText: locals.password,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              keyboardType: TextInputType.visiblePassword,
              errorStyle: const TextStyle(
                height: 0.01,
              ),
            ),
            const SizedBox(height: 16),
            BodySmallText(
              locals.passwordRule,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
