import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:device_region/device_region.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart' as get_it;
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/country_dropdown.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
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
    return FunScaffold(
      appBar: AppBar(
        leading: const BackButton(),
        scrolledUnderElevation: 0,
      ),
      body: BlocListener<AuthCubit, AuthState>(
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
                isUSUser: selectedCountry == Country.us,
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TitleLargeText(
                locals.welcomeContinue,
              ),
              const SizedBox(height: 4),
              BodyMediumText(
                locals.toGiveWeNeedYourEmailAddress,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              BodySmallText.primary40(locals.weWontSendAnySpam),
              const Spacer(),
              OutlinedTextFormField(
                controller: _emailController,
                hintText: locals.email,
                onChanged: (value) {
                  setState(() {
                    _formKey.currentState!.validate();
                  });
                },
                validator: (value) {
                  final isUnknownStatus =
                      context.read<AuthCubit>().state.status ==
                          AuthStatus.unknown;

                  if (!isUnknownStatus &&
                      (value == null ||
                          value.isEmpty ||
                          !Util.emailRegEx.hasMatch(value))) {
                    return context.l10n.invalidEmail;
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email,
                ],
              ),
              const SizedBox(height: 12),
              CountryDropDown(
                selectedCountry: selectedCountry,
                onChanged: (Country? newValue) {
                  setState(() {
                    selectedCountry = newValue!;
                  });
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    useSafeArea: true,
                    scrollControlDisabledMaxHeightRatio: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    builder: (BuildContext context) =>
                        const TermsAndConditionsDialog(
                      typeOfTerms: TypeOfTerms.termsAndConditions,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        FontAwesomeIcons.circleInfo,
                        size: 20,
                        color: FamilyAppTheme.primary20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: BodySmallText.primary40(
                          locals.acceptTerms,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                FunButton(
                  isDisabled: !isEnabled,
                  onTap: isEnabled
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
                  text: locals.continueKey,
                  rightIcon: FontAwesomeIcons.arrowRight,
                ),
            ],
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
    get_it.getIt<RequestHelper>().updateApiUrl(baseUrl, baseUrlAWS);
    get_it.getIt<RequestHelper>().country = selectedCountry.countryCode;

    // update country iso in shared preferences
    final prefs = get_it.getIt<SharedPreferences>();
    unawaited(prefs.setString(Util.countryIso, selectedCountry.countryCode));
  }
}
