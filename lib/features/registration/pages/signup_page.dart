import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/pages/mandate_explanation_page.dart';
import 'package:givt_app/features/registration/pages/personal_info_page.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/injection.dart';
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
      builder: (_) => BlocProvider(
        create: (_) => RegistrationBloc(getIt()),
        child: SignUpPage(
          email: email,
        ),
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
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const RegistrationAppBar(),
      resizeToAvoidBottomInset: false,
      bottomSheet: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAcceptPolicy(locals),
            ElevatedButton(
              onPressed: _isEnabled ? _register : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(
                locals.next,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state.status == RegistrationStatus.personalInfo) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: context.read<RegistrationBloc>(),
                    child: const PersonalInfoPage(),
                  ),
                ),
              );
            }
            if (state.status == RegistrationStatus.mandateExplanation) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: context.read<RegistrationBloc>(),
                    child: const MandateExplanationPage(),
                  ),
                ),
              );
            }
          },
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
                  onChanged: (value) => setState(() {
                    _formKey.currentState!.validate();
                  }),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).firstName,
                    errorStyle: const TextStyle(
                      height: 0,
                    ),
                  ),
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
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).lastName,
                    errorStyle: const TextStyle(
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  readOnly: widget.email.isNotEmpty,
                  controller: _emailController,
                  onChanged: (value) => setState(() {
                    _formKey.currentState!.validate();
                  }),
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
                    errorStyle: const TextStyle(
                      height: 0,
                    ),
                  ),
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
                  obscureText: _obscureText,
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 16),
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
                ),
                const SizedBox(height: 16),
                Text(
                  locals.passwordRule,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate() == false) {
      setState(() {
        isLoading = false;
      });
      return;
    }
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

  bool get _isEnabled =>
      _acceptPolicy == true && _formKey.currentState!.validate();

  Widget _buildAcceptPolicy(AppLocalizations locals) {
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        builder: (BuildContext context) => const TermsAndConditionsDialog(
          typeOfTerms: TypeOfTerms.privacyPolicy,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _acceptPolicy,
            onChanged: (value) {
              setState(() {
                _acceptPolicy = value!;
              });
            },
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: locals.acceptPolicy,
                ),
                const WidgetSpan(
                  child: Icon(Icons.info_rounded, size: 16),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
