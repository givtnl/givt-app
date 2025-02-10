import 'dart:async';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/country_dropdown.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_cubit.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_custom.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/dialogs/internet_connection_lost_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/shared/widgets/theme/app_theme_switcher.dart';
import 'package:givt_app/utils/auth_utils.dart';
import 'package:go_router/go_router.dart';

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
  bool _isLoading = false;

  final _cubit = getIt<EmailSignupCubit>();
  final _connectionCubit = getIt<InternetConnectionCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void setLoading({bool state = true}) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void initState() {
    super.initState();

    _checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);

    return BlocListener<InternetConnectionCubit, InternetConnectionState>(
      bloc: _connectionCubit,
      listener: (context, state) {
        if (state is InternetConnectionLost) {
          InternetConnectionLostDialog.show(context);
        }
      },
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state.status == AuthStatus.loginRedirect) {
            AuthUtils.checkToken(
              context,
              checkAuthRequest: CheckAuthRequest(
                navigate: (context) async => context.goNamed(Pages.home.name),
                email: state.email.trim(),
                forceLogin: true,
              ),
            );
          } else if (state.status == AuthStatus.noInternet) {
            setLoading(state: false);
            showDialog<void>(
              context: context,
              builder: (context) => WarningDialog(
                title: context.l10n.noInternetConnectionTitle,
                content: context.l10n.noInternet,
                onConfirm: () => context.pop(),
              ),
            );
          }
        },
        child: BaseStateConsumer(
          cubit: _cubit,
          onLoading: (context) => const FunScaffold(
            body: Center(
              child: CustomCircularProgressIndicator(),
            ),
          ),
          onCustom: handleCustom,
          onData: (context, state) => FunScaffold(
            minimumPadding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
            ),
            body: LayoutBuilder(
              builder: (context, constraint) {
                final isUS = true == state.country?.isUS;
                return SingleChildScrollView(
                  reverse: true,
                  key: const ValueKey('Email-Signup-Scrollable'),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraint.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            Image.asset(
                              isUS
                                  ? 'assets/images/logo_green.png'
                                  : 'assets/images/logo.png',
                              width: 100,
                            ),
                            if (isUS)
                              const SizedBox(
                                height: 24,
                              ),
                            if (!isUS) const Spacer(),
                            TitleLargeText(
                              isUS ? 'Welcome, super family!' : locals.letsGo,
                            ),
                            const SizedBox(height: 4),
                            BodyMediumText(
                              isUS
                                  ? "Let's foster generosity together"
                                  : locals.startJourneyOfGenerosity,
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            if (isUS && size.height > 750)
                              SvgPicture.asset(
                                'assets/family/images/captain.svg',
                              ),
                            CountryDropDown(
                              selectedCountry: state.country,
                              onChanged: (Country? newValue) {
                                _cubit.updateCountry(newValue!);
                              },
                            ),
                            const SizedBox(height: 12),
                            OutlinedTextFormField(
                              key: const ValueKey('Email-Input'),
                              initialValue: state.email,
                              hintText: locals.email,
                              onChanged: _cubit.updateEmail,
                              validator: (value) {
                                if (!_cubit.validateEmail(value)) {
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
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: state.country == null
                                    ? null
                                    : () => showModalBottomSheet<void>(
                                          context: context,
                                          useSafeArea: true,
                                          scrollControlDisabledMaxHeightRatio:
                                              1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          builder: (BuildContext context) =>
                                              TermsAndConditionsDialog(
                                            content: locals.termsText,
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
                                      child: BodySmallText(
                                        locals.acceptTerms,
                                        color: state.country == null
                                            ? FamilyAppTheme.neutralVariant40
                                            : FamilyAppTheme.primary40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            FunButton(
                              key: const ValueKey('Email-Continue-Button'),
                              isDisabled: !state.continueButtonEnabled,
                              isLoading: _isLoading,
                              onTap: state.continueButtonEnabled
                                  ? () async {
                                      _cubit.updateApi();
                                      if (state.country?.isUS == true) {
                                        final fbsdk = FacebookAppEvents();
                                        await fbsdk
                                            .setAutoLogAppEventsEnabled(true);
                                        await fbsdk.logEvent(
                                          name: 'email_signup_continue_clicked',
                                        );

                                        await _cubit.login();
                                      } else {
                                        setLoading();
                                        AppThemeSwitcher.of(context)
                                            .switchTheme(isFamilyApp: false);
                                        await context
                                            .read<AuthCubit>()
                                            .register(
                                              country: state.country!,
                                              email: state.email,
                                              locale: Localizations.localeOf(
                                                      context)
                                                  .languageCode,
                                            );
                                        setLoading(state: false);
                                      }
                                    }
                                  : null,
                              text: locals.continueKey,
                              rightIcon: FontAwesomeIcons.arrowRight,
                              analyticsEvent: AnalyticsEvent(
                                AmplitudeEvents.emailSignupContinueClicked,
                                parameters: {
                                  'email': state.email,
                                  'country': state.country?.name,
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleCustom(
      BuildContext context, EmailSignupCustom custom) async {
    switch (custom) {
      case EmailSignupCheckingEmail():
        setLoading();
      case EmailSignupShowFamilyRegistration():
        setLoading(state: false);
        AppThemeSwitcher.of(context).switchTheme(isFamilyApp: true);
        context.goNamed(
          FamilyPages.registrationUS.name,
          queryParameters: {
            'email': custom.email,
          },
        );
      case EmailSignupShowFamilyLogin():
        setLoading(state: false);
        AppThemeSwitcher.of(context).switchTheme(isFamilyApp: true);
        await FamilyAuthUtils.authenticateUser(
          context,
          checkAuthRequest: FamilyCheckAuthRequest(
            useBiometrics: false,
            email: custom.email,
            navigate: (context) async => context.pushReplacementNamed(
              FamilyPages.permitUSBiometric.name,
              extra: PermitBiometricRequest.registration(
                redirect: (context) {
                  context.goNamed(FamilyPages.profileSelection.name);
                },
              ),
            ),
          ),
        );
      case EmailSignupNoInternet():
        setLoading(state: false);
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: context.l10n.noInternetConnectionTitle,
            content: context.l10n.noInternet,
            onConfirm: () => context.pop(),
          ),
        );
      case EmailSignupCertExpired():
        setLoading();
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: context.l10n.certExceptionTitle,
            content: context.l10n.certExceptionBody,
            onConfirm: () => context.pop(),
          ),
        );
    }
  }

  /// EU (Legacy) Code
  Future<void> _checkAuthentication() async {
    final user = context.read<AuthCubit>().state.user;
    if (user.needRegistration || user.isUsUser) return;

    // Without biometrics we use the regular route to login
    if (!await LocalAuthInfo.instance.canCheckBiometrics) return;

    // When not authenticated do nothing
    final hasAuthenticated = await LocalAuthInfo.instance.authenticate();
    if (!hasAuthenticated) return;

    // When authenticated we go to the home route
    if (!mounted) return;
    await context.read<AuthCubit>().authenticate();

    if (!mounted) return;
    context.goNamed(Pages.home.name);
  }
}
