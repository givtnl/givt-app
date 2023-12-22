import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/change_password_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.email = '',
    this.popWhenSuccess = false,
  });

  final String email;
  final bool popWhenSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController();
  }

  Future<void> onLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        await context
            .read<AuthCubit>()
            .login(
              email: emailController.text,
              password: passwordController.text,
            )
            .whenComplete(() {
          if (widget.popWhenSuccess &&
              context.read<AuthCubit>().state.status ==
                  AuthStatus.authenticated) {
            context.pop();
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
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;

    return BottomSheetLayout(
      title: Text(
        locals.login,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: context.watch<AuthCubit>().state.status == AuthStatus.loading
            ? null
            : isEnabled
                ? () => onLogin(context)
                : null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey,
        ),
        child: context.watch<AuthCubit>().state.status == AuthStatus.loading
            ? const CircularProgressIndicator.adaptive()
            : Text(
                locals.login,
              ),
      ),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure) {
            showDialog<void>(
              context: context,
              builder: (context) => WarningDialog(
                title: locals.loginFailure,
                content: locals.wrongCredentials,
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
        },
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                locals.loginText,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.05),
              CustomTextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                readOnly: widget.popWhenSuccess,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email
                ],
                onChanged: (value) {
                  setState(() {
                    formKey.currentState!.validate();
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
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: passwordController,
                autocorrect: false,
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
                padding: const EdgeInsets.only(top: 15),
                child: Align(
                  child: TextButton(
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => ChangePasswordPage(
                        email: emailController.text,
                      ),
                    ),
                    child: Text(
                      locals.forgotPassword,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
