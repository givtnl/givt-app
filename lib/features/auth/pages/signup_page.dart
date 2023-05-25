import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    this.email = '',
  });
  final String email;
  static MaterialPageRoute<dynamic> route({String email = ''}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => SignUpPage(
        email: email,
      ),
    );
  }

  @override
  _SignUpPageState createState() => _SignUpPageState();
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

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: size.height * 0.04,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark_outlined),
            onPressed: () {
              ///todo add faq here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
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
                  return null;
                },
                textInputAction: TextInputAction.next,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).firstName,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).lastName,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.contains('@') == false) {
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
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
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
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 16),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).password,
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(8),
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
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _buildAcceptPolicy(locals),
              ElevatedButton(
                onPressed: _acceptPolicy == true
                    ? () {
                        // Register user logic
                      }
                    : null,
                child: Text(locals.next),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildAcceptPolicy(AppLocalizations locals) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Checkbox(
              value: _acceptPolicy,
              onChanged: (value) {
                setState(() {
                  _acceptPolicy = value!;
                });
              },
            ),
          ),
          TextSpan(
            text: locals.acceptPolicy,
          ),
          const WidgetSpan(
            child: Icon(Icons.info_rounded, size: 16),
          ),
        ],
      ),
    );
  }
}
