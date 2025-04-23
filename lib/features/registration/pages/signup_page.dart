import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/acceptPolicyRow.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/analytics_helper.dart';
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
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);

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
        return Scaffold(
          appBar: RegistrationAppBar(
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
    TextInput.finishAutofillContext(); // <-- this
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate() == false &&
        _selectedCountry != Country.us) {
      setState(() {
        isLoading = false;
      });
    }
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.registrationFilledInPersonalInfoSheetFilled,
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
    if (_formKey.currentState == null) return false;
    if (_acceptPolicy == true && _formKey.currentState!.validate()) return true;
    return false;
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
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
              locals.next,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(AppLocalizations locals, Size size) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
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
              autofillHints: const [AutofillHints.givenName],
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).firstName,
                errorStyle: const TextStyle(
                  height: 0,
                ),
              ),
              keyboardType: TextInputType.name,
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
              autofillHints: const [AutofillHints.familyName],
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).surname,
                errorStyle: const TextStyle(
                  height: 0,
                ),
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
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
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username,
              ],
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
              keyboardType: TextInputType.emailAddress,
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
              autofillHints: const [
                AutofillHints.password,
                AutofillHints.newPassword,
              ],
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
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            Text(
              locals.passwordRule,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
