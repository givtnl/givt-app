// Here's the code block for the page with an input field, register button, and forgot password button using Flutter/Dart:

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/features/auth/pages/login_page.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';

class EmailSignupPage extends StatelessWidget {
  const EmailSignupPage({super.key});

  static CupertinoPageRoute<dynamic> route() {
    return CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (_) => const EmailSignupPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const InputPage();
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          locals.welcomeContinue,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                locals.toGiveWeNeedYourEmailAddress,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(locals.weWontSendAnySpam),
              const Spacer(),
              TextFormField(
                controller: _emailController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: locals.email,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.contains('@') == false) {
                    return AppLocalizations.of(context).invalidEmail;
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  builder: (BuildContext context) =>
                      const TermsAndConditionsDialog(
                    typeOfTerms: TypeOfTerms.termsAndConditions,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          locals.acceptTerms,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const Icon(Icons.info_outline_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: const Size.fromHeight(40),
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onPressed:
                    _emailController.value.text.isNotEmpty ? () {} : null,
                child: Text(locals.continueText),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(LoginPage.route()),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    children: <TextSpan>[
                      TextSpan(
                        text: locals.alreadyAnAccount,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(),
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
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        children: [],
      ),
    );
  }
}
