import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';

class EmailSignupPage extends StatefulWidget {
  const EmailSignupPage({super.key});

  static CupertinoPageRoute<dynamic> route() {
    return CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (_) => const EmailSignupPage(),
    );
  }

  @override
  _EmailSignupPageState createState() => _EmailSignupPageState();
}

class _EmailSignupPageState extends State<EmailSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          locals.welcomeContinue,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is AuthLoginRedirect) {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (BuildContext context) => LoginPage(
                  email: state.email.trim(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    locals.toGiveWeNeedYourEmailAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(locals.weWontSendAnySpam),
                  const Spacer(),
                  TextFormField(
                    controller: _emailController,
                    onChanged: (value) {
                      setState(() {
                        _formKey.currentState!.validate();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: locals.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !Util.emailRegEx.hasMatch(value)) {
                        return context.l10n.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      useSafeArea: true,
                      backgroundColor: AppTheme.givtPurple,
                      builder: (BuildContext context) =>
                          const TermsAndConditionsDialog(
                        typeOfTerms: TypeOfTerms.termsAndConditions,
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: locals.acceptTerms,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const WidgetSpan(
                            child: Icon(Icons.info_rounded, size: 16),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: isEnabled
                          ? () async {
                              toggleLoading();
                              if (_formKey.currentState!.validate()) {
                                await context.read<AuthCubit>().register(
                                      email: _emailController.value.text.trim(),
                                      locale: Localizations.localeOf(context)
                                          .languageCode,
                                    );
                              }
                              toggleLoading();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        locals.continueKey,
                      ),
                    ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                    child: _buildAlreadyHaveAnAccount(locals, context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get isEnabled {
    if (_formKey.currentState == null) return false;
    if (_formKey.currentState!.validate() == false) return false;
    return _emailController.text.isNotEmpty;
  }

  Text _buildAlreadyHaveAnAccount(
    AppLocalizations locals,
    BuildContext context,
  ) =>
      Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: locals.alreadyAnAccount,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: locals.login,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
}
