import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/stripe_response.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/color_schemes.g.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    this.email = '',
    this.createStripe = 'false',
  });
  final String email;
  final String createStripe;
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
    if (widget.createStripe.contains('true')) {
      context.read<RegistrationBloc>().add(const RegistrationStripeInit());
    }
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final stripeCubit = context.read<StripeCubit>();

    return BlocBuilder<StripeCubit, StripeState>(
      builder: (context, stripestate) {
        return Scaffold(
          appBar: stripestate.stripeStatus == StripeObjectStatus.display
              ? null
              : RegistrationAppBar(
                  actions: [
                    IconButton(
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        showDragHandle: true,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        builder: (_) => const FAQBottomSheet(),
                      ),
                      icon: const Icon(
                        Icons.question_mark_outlined,
                        size: 26,
                      ),
                    ),
                  ],
                ),
          resizeToAvoidBottomInset: false,
          bottomSheet: stripestate.stripeStatus == StripeObjectStatus.display
              ? _createInAppWebview(context, stripeCubit.state.stripeObject)
              : Container(
                  margin: const EdgeInsets.only(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: stripestate.stripeStatus == StripeObjectStatus.initial
                      ? Column(
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
                        )
                      : const SizedBox()),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<RegistrationBloc, RegistrationState>(
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
                if (state.status == RegistrationStatus.createStripeAccount) {
                  context.read<StripeCubit>().fetchStripeCustomerCreationURLs();
                }
              },
              builder: (context, state) {
                return (state.status ==
                            RegistrationStatus.createStripeAccount ||
                        stripestate.stripeStatus == StripeObjectStatus.success)
                    ? _createView(stripeCubit.state.stripeStatus)
                    : _buildSignUpForm(locals, size);
              },
            ),
          ),
        );
      },
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

  bool get _isEnabled {
    if (_formKey.currentState == null) return false;
    if (_acceptPolicy == true && _formKey.currentState!.validate()) return true;
    return false;
  }

  Widget _buildSignUpForm(AppLocalizations locals, Size size) {
    return Form(
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
              if (!Util.nameFieldsRegEx.hasMatch(value)) {
                return '';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onChanged: (value) => setState(() {
              _formKey.currentState!.validate();
            }),
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
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
              if (!Util.nameFieldsRegEx.hasMatch(value)) {
                return '';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).lastName,
              errorStyle: const TextStyle(
                height: 0,
              ),
            ),
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
    );
  }

  Widget _buildAcceptPolicy(AppLocalizations locals) {
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: AppTheme.givtPurple,
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
                WidgetSpan(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      locals.acceptPolicy,
                    ),
                  ),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.info_rounded,
                    size: 16,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _createView(StripeObjectStatus status) {
    if (status == StripeObjectStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (status == StripeObjectStatus.failure) {
      return const Text('Could not connect to Stripe');
    }
    if (status == StripeObjectStatus.success) {
      return const Center(child: CircularProgressIndicator());
    }
    return Text('Stripe status $status');
  }

  Widget _createInAppWebview(BuildContext context, StripeResponse response) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(response.url)),
        onWebViewCreated: (controller) {
          controller.loadUrl(
              urlRequest: URLRequest(url: Uri.parse(response.url)));
        },
        onLoadStart: (controller, url) {
          if (url == Uri.parse(response.cancelUrl)) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration cancelled'),
              ),
            );
          } else if (url == Uri.parse(response.successUrl)) {
            context.read<StripeCubit>().stripeRegistrationComplete();
            context
                .read<RegistrationBloc>()
                .add(const RegistrationStripeSuccess());

            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: 'Registration successful',
                content:
                    'Your registration might take some time complete, but you can already donate!',
                onConfirm: () {
                  context
                    ..pop()
                    ..goNamed(Pages.home.name);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
