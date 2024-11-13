import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/login/cubit/family_login_cubit.dart';
import 'package:givt_app/features/family/features/login/presentation/models/family_login_sheet_custom.dart';
import 'package:givt_app/features/family/features/reset_password/presentation/pages/reset_password_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class FamilyLoginSheet extends StatefulWidget {
  const FamilyLoginSheet({
    required this.navigate,
    this.email,
    super.key,
  });

  final String? email;
  final Future<void> Function(BuildContext context) navigate;

  @override
  State<FamilyLoginSheet> createState() => _FamilyLoginSheetState();
}

class _FamilyLoginSheetState extends State<FamilyLoginSheet> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool obscureText = true;

  final _cubit = getIt<FamilyLoginCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cubit.init(widget.email);
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> onLogin(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    await _cubit.login(
      emailController.text,
      passwordController.text,
    );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onCustom: onCustom,
      onData: (context, data) => showLoginForm(data),
      onLoading: (context) {
        return FunBottomSheet(
          title: context.l10n.login,
          icon: const CustomCircularProgressIndicator(),
          content: const BodyMediumText(
            "We're logging you in",
          ),
        );
      },
    );
  }

  Widget showLoginForm(String email) {
    emailController.text = email;

    return FunBottomSheet(
      title: context.l10n.login,
      closeAction: () => context.pop(),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            BodyMediumText(
              context.l10n.loginText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedTextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
              ],
              onChanged: (value) {
                setState(() {
                  formKey.currentState!.validate();
                });
              },
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !Util.emailRegEx.hasMatch(value)) {
                  return context.l10n.invalidEmail;
                }
                return null;
              },
              hintText: context.l10n.email,
            ),
            const SizedBox(height: 16),
            OutlinedTextFormField(
              controller: passwordController,
              autofillHints: const [AutofillHints.password],
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                setState(() {
                  formKey.currentState!.validate();
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.passwordRule;
                }
                if (value.length < 7) {
                  return context.l10n.passwordRule;
                }
                if (value.contains(RegExp('[0-9]')) == false) {
                  return context.l10n.passwordRule;
                }
                if (value.contains(RegExp('[A-Z]')) == false) {
                  return context.l10n.passwordRule;
                }

                return null;
              },
              obscureText: obscureText,
              textInputAction: TextInputAction.done,
              hintText: context.l10n.password,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Align(
                child: TextButton(
                  onPressed: () => ResetPasswordSheet(
                    initialEmail: emailController.text,
                  ).show(context),
                  child: TitleSmallText(
                    context.l10n.forgotPassword,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      primaryButton: FunButton(
        isDisabled: !isEnabled,
        onTap: isEnabled ? () => onLogin(context) : null,
        text: context.l10n.login,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.loginClicked,
        ),
      ),
    );
  }

  Future<void> onCustom(
    BuildContext context,
    FamilyLoginSheetCustom state,
  ) async {
    switch (state) {
      case LoginSuccess():
        if (!context.mounted) return;
        await widget.navigate(context);

        if (!context.mounted) return;
        context.pop();
      case TwoAttemptsLeftDialog():
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: context.l10n.loginFailure,
            content: context.l10n.wrongCredentials,
            onConfirm: () => context.pop(),
          ),
        );
      case OneAttemptLeftDialog():
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: context.l10n.loginFailure,
            content: context.l10n.wrongCredentials,
            onConfirm: () => context.pop(),
          ),
        );
      case LockedOutDialog():
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: context.l10n.loginFailure,
            content: context.l10n.wrongPasswordLockedOut,
            onConfirm: () => context.pop(),
          ),
        );
      case FailureDialog():
        await showDialog<void>(
          context: context,
          builder: (context) => WarningDialog(
            title: context.l10n.loginFailure,
            content: context.l10n.wrongCredentials,
            onConfirm: () => context.pop(),
          ),
        );
    }
  }
}
