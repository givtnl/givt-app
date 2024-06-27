import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:device_region/device_region.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart' as get_it;
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailSignupPage extends StatefulWidget {
  const EmailSignupPage({
    super.key,
  });

  static CupertinoPageRoute<dynamic> route() {
    return CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (_) => const EmailSignupPage(),
    );
  }

  @override
  State<EmailSignupPage> createState() => _EmailSignupPageState();
}

class _EmailSignupPageState extends State<EmailSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  Country selectedCountry = Country.nl;
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    setEmail();
    setDefaultCountry();
  }

  Future<void> setEmail() async {
    var email = context.read<AuthCubit>().state.email;
    final prefs = await SharedPreferences.getInstance();

    if (email.isEmpty && prefs.containsKey(UserExt.tag)) {
      final user = UserExt.fromJson(
        jsonDecode(prefs.getString(UserExt.tag)!) as Map<String, dynamic>,
      );
      email = user.email;
    }

    setState(() {
      _emailController.text = email;
    });
  }

  Future<void> setDefaultCountry() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(UserExt.tag)) {
      final user = UserExt.fromJson(
        jsonDecode(prefs.getString(UserExt.tag)!) as Map<String, dynamic>,
      );
      setState(() {
        selectedCountry = Country.fromCode(user.country);
      });
      return;
    }

    final countryCode = await DeviceRegion.getSIMCountryCode();

    if (countryCode == null) {
      return;
    }
    if (countryCode.isEmpty) {
      return;
    }
    if (Country.fromCode(countryCode) == Country.unknown) {
      return;
    }
    setState(() {
      selectedCountry = Country.fromCode(countryCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

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
            if (state.status == AuthStatus.loginRedirect) {
              AuthUtils.checkToken(
                context,
                checkAuthRequest: CheckAuthRequest(
                  navigate: (context, {isUSUser}) async => context.goNamed(
                    true == isUSUser
                        ? FamilyPages.profileSelection.name
                        : Pages.home.name,
                  ),
                  email: state.email.trim(),
                  forceLogin: true,
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
            if (state.status == AuthStatus.certificateException) {
              showDialog<void>(
                context: context,
                builder: (context) => WarningDialog(
                  title: locals.certExceptionTitle,
                  content: locals.certExceptionBody,
                  onConfirm: () => context.pop(),
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
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email,
                    ],
                    autocorrect: false,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !Util.emailRegEx.hasMatch(value)) {
                        return context.l10n.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Country>(
                    value: selectedCountry,
                    decoration: InputDecoration(
                      labelText: locals.country,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                    ),
                    menuMaxHeight: MediaQuery.sizeOf(context).height * 0.3,
                    items: Country.sortedCountries()
                        .where((element) => element != Country.unknown)
                        .map(
                          (Country country) => DropdownMenuItem(
                            value: country,
                            child: Text(
                              Country.getCountryIncludingEmoji(
                                country.countryCode,
                                locals,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (Country? newValue) {
                      setState(() {
                        selectedCountry = newValue!;
                      });
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
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
                                // Update country
                                _updateCountry();

                                await context.read<AuthCubit>().register(
                                      country: selectedCountry,
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

  void _updateCountry() {
    var baseUrl = const String.fromEnvironment('API_URL_EU');
    var baseUrlAWS = const String.fromEnvironment('API_URL_AWS_EU');

    if (selectedCountry == Country.us) {
      baseUrl = const String.fromEnvironment('API_URL_US');
      baseUrlAWS = const String.fromEnvironment('API_URL_AWS_US');
    }

    log('Using API URL: $baseUrl');
    get_it.getIt<APIService>().updateApiUrl(baseUrl, baseUrlAWS);

    // update country iso in shared preferences
    final prefs = get_it.getIt<SharedPreferences>();
    unawaited(prefs.setString(Util.countryIso, selectedCountry.countryCode));
  }
}
