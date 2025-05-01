import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/reset_password/presentation/pages/reset_password_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.email,
    required this.isEmailEditable,
    this.navigate,
    super.key,
  });

  final String email;
  final bool isEmailEditable;
  final Future<void> Function(BuildContext context)? navigate;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool obscureText = true;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController();
  }

  Future<void> onLogin(BuildContext context) async {
    // This will trigger the autofill context too many times
    // TextInput.finishAutofillContext();

    if (formKey.currentState!.validate()) {
      try {
        await context
            .read<AuthCubit>()
            .login(
              email: emailController.text,
              password: passwordController.text,
              navigate: widget.navigate,
            )
            .whenComplete(() {
          final authState = context.read<AuthCubit>().state;

          if (authState.status == AuthStatus.authenticated ||
              authState.status == AuthStatus.biometricCheck) {
            context.pop(true);
          }
        });
      } catch (e) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          showDialog<void>(
            context: context,
            builder: (context) => WarningDialog(
              title: locals.loginFailure,
              content: locals.noInternet,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status == AuthStatus.noInternet) {
          showDialog<void>(
            context: context,
            builder: (context) => WarningDialog(
              title: locals.noInternetConnectionTitle,
              content: locals.noInternet,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status == AuthStatus.twoAttemptsLeft) {
          showDialog<void>(
            context: context,
            builder: (context) => WarningDialog(
              title: locals.loginFailure,
              content: locals.wrongCredentials,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status == AuthStatus.oneAttemptLeft) {
          showDialog<void>(
            context: context,
            builder: (context) => WarningDialog(
              title: locals.loginFailure,
              content: locals.wrongCredentials,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status == AuthStatus.lockedOut) {
          showDialog<void>(
            context: context,
            builder: (context) => WarningDialog(
              title: locals.loginFailure,
              content: locals.wrongPasswordLockedOut,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status == AuthStatus.accountDisabled) {
          showDialog<void>(
            context: context,
            builder: (context) => WarningDialog(
              title: locals.loginFailure,
              content: locals.accountDisabled,
              onConfirm: () => context.pop(),
            ),
          );
        }
      },
      child: _buildLoginForm(context, locals),
    );
  }

  Widget _buildLoginForm(BuildContext context, AppLocalizations locals) {
    final isLoading =
        context.watch<AuthCubit>().state.status == AuthStatus.loading;

    return FunBottomSheet(
      title: locals.login,
      closeAction: () => context.pop(),
      content: Form(
        key: formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              BodyMediumText(
                locals.loginText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedTextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: !widget.isEmailEditable,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                onChanged: (value) {
                  if (_debounceTimer?.isActive ?? false)
                    _debounceTimer!.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                    setState(() {
                      formKey.currentState!.validate();
                    });
                  });
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !Util.emailRegEx.hasMatch(value)) {
                    return locals.invalidEmail;
                  }
                  return null;
                },
                hintText: locals.email,
              ),
              const SizedBox(height: 16),
              OutlinedTextFormField(
                key: const ValueKey('Login-Bottomsheet-Password-Input'),
                controller: passwordController,
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  setState(() {
                    formKey.currentState!.validate();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return locals.passwordRule;
                  }
                  if (value.length < 7) {
                    return locals.passwordRule;
                  }
                  if (value.contains(RegExp('[0-9]')) == false) {
                    return locals.passwordRule;
                  }
                  if (value.contains(RegExp('[A-Z]')) == false) {
                    return locals.passwordRule;
                  }

                  return null;
                },
                obscureText: obscureText,
                textInputAction: TextInputAction.done,
                hintText: locals.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    semanticLabel: 'passwordeye',
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Align(
                  child: TextButton(
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => ResetPasswordSheet(
                        initialEmail: emailController.text,
                      ),
                    ),
                    child: TitleSmallText(
                      locals.forgotPassword,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      primaryButton: FunButton(
        isDisabled: !isEnabled || isLoading,
        onTap: isEnabled && !isLoading ? () => onLogin(context) : null,
        text: locals.login,
        isLoading: isLoading,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.loginClicked,
        ),
      ),
    );
  }
}
