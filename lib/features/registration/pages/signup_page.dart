import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
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
    final isUS = _selectedCountry == Country.us;

    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (!(_selectedCountry == Country.us) &&
            state.status == RegistrationStatus.personalInfo) {
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
          context.goNamed(
            Pages.creditCardDetail.name,
            extra: context.read<RegistrationBloc>(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: RegistrationAppBar(
            title: isUS
                ? Text(
                    locals.signUpPageTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                  )
                : null,
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
                ? _buildLoadingState(isUS)
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            _buildSignUpForm(locals, size, isUS),
                            const Spacer(),
                            _buildBottomWidgetGroup(locals, size, isUS),
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
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate() == false &&
        _selectedCountry != Country.us) {
      setState(() {
        isLoading = false;
      });
    }
    context.read<RegistrationBloc>().add(
          RegistrationPasswordSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
          ),
        );
    if (_selectedCountry == Country.us) {
      context.read<RegistrationBloc>().add(
            RegistrationPersonalInfoSubmitted(
              address: Util.defaultAdress,
              city: Util.defaultCity,
              postalCode: Util.defaultPostCode,
              country: _selectedCountry.countryCode,
              phoneNumber: Util.defaultUSPhoneNumber,
              iban: Util.defaultIban,
              sortCode: Util.empty,
              accountNumber: Util.empty,
              appLanguage: Localizations.localeOf(context).languageCode,
              countryCode: _selectedCountry.countryCode,
            ),
          );
      return;
    }
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

  Widget _buildLoadingState(bool isUS) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isUS) const Text('Hold on, we are creating your account...'),
          if (isUS) const SizedBox(height: 16),
          const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }

  Widget _buildBottomWidgetGroup(
    AppLocalizations locals,
    Size size,
    bool isUS,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
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
              isUS ? locals.enterPaymentDetails : locals.next,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(AppLocalizations locals, Size size, bool isUS) {
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
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
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
              hintText: AppLocalizations.of(context).surname,
              errorStyle: const TextStyle(
                height: 0,
              ),
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          Visibility(
            visible: !isUS,
            child: const SizedBox(height: 16),
          ),
          Visibility(
            visible: !isUS,
            child: TextFormField(
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
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAcceptPolicy(AppLocalizations locals) {
    return GestureDetector(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: AppTheme.givtPurple,
        builder: (_) => const TermsAndConditionsDialog(
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
}
