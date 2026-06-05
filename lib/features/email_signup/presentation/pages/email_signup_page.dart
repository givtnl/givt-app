import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/country_dropdown.dart';
import 'package:givt_app/features/auth/widgets/terms_and_conditions_dialog.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_cubit.dart';
import 'package:givt_app/features/email_signup/cubit/email_signup_custom.dart';
import 'package:givt_app/features/email_signup/presentation/models/email_signup_uimodel.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/internet_connection/internet_connection_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/dialogs/internet_connection_lost_dialog.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
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
  bool _emailHydrated = false;
  late final TextEditingController _emailController;
  StreamSubscription<dynamic>? _emailHydrationSub;

  final EmailSignupCubit _cubit = getIt<EmailSignupCubit>();
  final InternetConnectionCubit _connectionCubit = getIt<InternetConnectionCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cubit.init(
      language: Localizations.localeOf(context).languageCode,
    );
  }

  @override
  void dispose() {
    _emailHydrationSub?.cancel();
    _emailController.dispose();
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
    _emailController = TextEditingController();
    final cur = _cubit.state;
    if (cur is DataState<EmailSignupUiModel, EmailSignupCustom>) {
      _emailHydrated = true;
      _emailController.text = cur.data.email;
    } else {
      _emailHydrationSub = _cubit.stream.listen((state) {
        if (!_emailHydrated &&
            state is DataState<EmailSignupUiModel, EmailSignupCustom>) {
          _emailHydrated = true;
          _emailHydrationSub?.cancel();
          _emailHydrationSub = null;
          if (mounted) {
            setState(() {
              _emailController.text = state.data.email;
            });
          }
        }
      });
    }

    _checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

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
                              'assets/images/logo.png',
                              width: 100,
                            ),
                            const Spacer(),
                            TitleLargeText(
                              locals.homescreenLetsGo,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            BodyMediumText(
                              locals.homescreenJourneyOfGenerosity,
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            CountryDropDown(
                              selectedCountry: state.country,
                              onChanged: (Country? newValue) {
                                _cubit.updateCountry(newValue!);
                              },
                            ),
                            const SizedBox(height: 12),
                            InputFormField(
                              key: const ValueKey('Email-Input'),
                              controller: _emailController,
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
                                            overrideCountryIso:
                                                state.country?.countryCode,
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
                                      // Hide keyboard when continue button is tapped
                                      FocusScope.of(context).unfocus();

                                      _cubit.updateApi();
                                      setLoading();
                                      AppThemeSwitcher.of(context)
                                          .switchTheme(isFamilyApp: false);
                                      try {
                                        await context
                                            .read<AuthCubit>()
                                            .register(
                                              country: state.country!,
                                              email: state.email,
                                              locale: Localizations.localeOf(
                                                      context)
                                                  .languageCode,
                                            );
                                      } catch (e) {
                                        // Error surfaced via AuthCubit / dialogs.
                                      }
                                      setLoading(state: false);
                                    }
                                  : null,
                              text: locals.buttonContinue,
                              analyticsEvent: AnalyticsEventName.emailSignupContinueClicked.toEvent(
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
        AppThemeSwitcher.of(context).switchTheme(isFamilyApp: false);
        context.goNamed(
          Pages.registration.name,
          queryParameters: {
            'email': custom.email,
          },
        );
      case EmailSignupShowFamilyLogin():
        setLoading(state: false);
        AppThemeSwitcher.of(context).switchTheme(isFamilyApp: false);
        await AuthUtils.checkToken(
          context,
          checkAuthRequest: CheckAuthRequest(
            email: custom.email,
            navigate: (context) async => context.goNamed(Pages.home.name),
            forceLogin: true,
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
      case final EmailSignupError error:
        setLoading(state: false);
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: 'An error occurred',
            content: error.message,
            onConfirm: () => context.pop(),
          ),
        );
    }
  }

  /// EU (Legacy) Code
  Future<void> _checkAuthentication() async {
    final user = context.read<AuthCubit>().state.user;
    if (user.needRegistration) return;

    // Without biometrics we use the regular route to login
    if (!await LocalAuthInfo.instance.canCheckBiometrics) return;

    // When not authenticated do nothing
    final hasAuthenticated = await LocalAuthInfo.instance.authenticate();
    if (!hasAuthenticated) return;

    // When authenticated we go to the home route
    if (!mounted) return;
    final didAuthenticate = await context.read<AuthCubit>().authenticate();

    if (!mounted) return;
    if (didAuthenticate) {
      context.goNamed(Pages.home.name);
    } else {
      await AuthUtils.displayLoginBottomSheet(
        context,
        checkAuthRequest: CheckAuthRequest(
          navigate: (context) async {
            context.goNamed(Pages.home.name);
          },
          email: user.email,
          forceLogin: true,
        ),
      );
    }
  }
}
