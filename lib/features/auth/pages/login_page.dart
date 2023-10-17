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
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // _country = widget.country;
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
  }

  Future<void> onLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await context
            .read<AuthCubit>()
            .login(
              email: _emailController.text,
              password: _passwordController.text,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;

    return SafeArea(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleRow(locals, context),
                Text(
                  locals.loginText,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.05),
                CustomTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: widget.popWhenSuccess,
                  autofillHints: const [AutofillHints.username],
                  onChanged: (value) {
                    _formKey.currentState!.validate();
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
                  controller: _passwordController,
                  autofillHints: const [AutofillHints.password],
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) {
                    _formKey.currentState!.validate();
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
                  obscureText: _obscureText,
                  textInputAction: TextInputAction.done,
                  hintText: locals.password,
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
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Align(
                    child: TextButton(
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) => ChangePasswordPage(
                          email: _emailController.text,
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
                Expanded(child: Container()),
                if (context.watch<AuthCubit>().state.status ==
                    AuthStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: () => onLogin(context),
                    child: Text(
                      locals.login,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildTitleRow(
    AppLocalizations locals,
    BuildContext context,
  ) =>
      Row(
        children: [
          const BackButton(),
          Text(
            locals.login,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      );
}
