import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/signup_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.email = ''});

  final String email;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool isLoading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
  }

  void toggleLoader(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  Future<void> onLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      toggleLoader(true);
      try {
        await context.read<AuthCubit>().login(
              email: _emailController.text,
              password: _passwordController.text,
            );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
    toggleLoader(false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);

    return SafeArea(
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthTempAccountWarning) {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(locals.temporaryAccount),
                content: Text(locals.tempAccountLogin),
                actions: [
                  TextButton(
                    child: Text(locals.continueKey),
                    onPressed: () => Navigator.of(context).pushReplacement(
                      SignUpPage.route(
                        email: _emailController.text,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is AuthFailure) {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(locals.loginFailure),
                content: Text(locals.wrongCredentials),
                actions: [
                  TextButton(
                    child: Text(locals.continueKey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
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
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.contains(Util.emailRegEx) == false) {
                      return AppLocalizations.of(context).invalidEmail;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).email,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return locals.wrongPasswordLockedOut;
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
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 16),
                  decoration: InputDecoration(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Align(
                    child: TextButton(
                      onPressed: () {
                        ///todo add forgot password page
                      },
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
                if (isLoading)
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
                  )
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
