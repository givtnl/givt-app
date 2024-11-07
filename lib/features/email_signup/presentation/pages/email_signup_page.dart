import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/enums/type_of_terms.dart';
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
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/utils.dart';
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

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
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

    return BaseStateConsumer(
      cubit: _cubit,
      onLoading: (context) => const FunScaffold(
        body: Center(
          child: CustomCircularProgressIndicator(),
        ),
      ),
      onCustom: handleCustom,
      onData: (context, state) => FunScaffold(
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
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
                        const SizedBox(height: 12),
                        CountryDropDown(
                          selectedCountry: state.country,
                          onChanged: (Country? newValue) {
                            _cubit.updateCountry(newValue!);
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
                            isDisabled: !state.continueButtonEnabled,
                            onTap: state.continueButtonEnabled
                                ? _cubit.login
                                : null,
                            text: locals.continueKey,
                            rightIcon: FontAwesomeIcons.arrowRight,
                            analyticsEvent: AnalyticsEvent(
                              AmplitudeEvents.emailSignupContinueClicked,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> handleCustom(
      BuildContext context, EmailSignupCustom custom) async {
    switch (custom) {
      case EmailSignupSuccess():
        await context.read<AuthCubit>().register(
              country: custom.country,
              email: custom.email,
              locale: Localizations.localeOf(context).languageCode,
            );
      case EmailSignupSuccessFamily():
        await FamilyAuthUtils.authenticateUser(
          context,
          checkAuthRequest: FamilyCheckAuthRequest(
            email: custom.email,
            navigate: (context) async =>
                context.goNamed(FamilyPages.profileSelection.name),
          ),
        );
      case EmailSignupNoInternet():
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: context.l10n.noInternetConnectionTitle,
            content: context.l10n.noInternet,
            onConfirm: () => context.pop(),
          ),
        );
      case EmailSignupCertExpired():
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

  /// This should be moved to the CUBIT
  Future<void> _checkAuthentication() async {
    // Without biometrics we use the regular route to login
    if (!await LocalAuthInfo.instance.canCheckBiometrics) return;

    // When not authenticated do nothing
    final hasAuthenticated = await LocalAuthInfo.instance.authenticate();
    if (!hasAuthenticated) return;

    // When authenticated we go to the home route
    // TODO US!!
    if (!mounted) return;
    await context.read<AuthCubit>().authenticate();

    if (!mounted) return;
    context.goNamed(Pages.home.name);
  }
}
