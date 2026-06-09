import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/util.dart';

class ResetPasswordSheet extends StatefulWidget {
  const ResetPasswordSheet({
    this.initialEmail = '',
    super.key,
  });

  final String initialEmail;

  @override
  State<ResetPasswordSheet> createState() => _ResetPasswordSheetState();

  Future<void> show(
    BuildContext context,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => this,
    );
  }
}

class _ResetPasswordSheetState extends State<ResetPasswordSheet> {
  late TextEditingController emailController;
  String? _emailError;

  final ResetPasswordCubit _cubit = getIt<ResetPasswordCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onInitial: (context) {
        return Semantics(
          identifier: 'accountSettingsChangePasswordSheet',
          child: FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: context.l10n.changePassword,
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                FunInput(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: (_) {
                    setState(() {
                      _emailError = null;
                    });
                  },
                  hintText: context.l10n.email,
                ),
                const SizedBox(height: 24),
                BodyMediumText(
                  context.l10n.forgotPasswordText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          primaryButton: FunButton(
            isDisabled: !isEnabled,
            onTap: isEnabled
                ? () {
                    if (!_validateEmail(context.l10n.invalidEmail)) {
                      return;
                    }
                    _cubit.resetPassword(emailController.text);
                  }
                : null,
            text: context.l10n.changePassword,
            analyticsEvent: AnalyticsEventName.changePasswordClicked.toEvent(),
          ),
        ),
        );
      },
      onLoading: (context) {
        return FunBottomSheet(
          title: context.l10n.changePassword,
          icon: const CustomCircularProgressIndicator(),
          content: const BodyMediumText(
            "We're processing your password reset",
          ),
        );
      },
      onData: (context, data) {
        return FunBottomSheet(
          title: context.l10n.changePassword,
          icon: primaryCircleWithIcon(
            circleSize: 140,
            iconData: FontAwesomeIcons.check,
            iconSize: 48,
          ),
          content: BodyMediumText(
            context.l10n.resetPasswordSent,
            textAlign: TextAlign.center,
          ),
          primaryButton: FunButton(
            text: context.l10n.buttonDone,
            analyticsEvent: AnalyticsEventName.okClicked.toEvent(),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          closeAction: () {
            Navigator.of(context).pop();
          },
        );
      },
      onError: (context, message) {
        return FunBottomSheet(
          title: context.l10n.changePassword,
          icon: errorCircleWithIcon(
            circleSize: 140,
            iconData: FontAwesomeIcons.triangleExclamation,
            iconSize: 48,
          ),
          content: Column(
            children: [
              BodyMediumText(
                context.l10n.somethingWentWrong,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          primaryButton: FunButton(
            text: 'Ok',
            analyticsEvent: AnalyticsEventName.okClicked.toEvent(),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          closeAction: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  bool _validateEmail(String invalidEmailMessage) {
    final value = emailController.text;
    if (value.isEmpty || !value.contains(Util.emailRegEx)) {
      setState(() {
        _emailError = invalidEmailMessage;
      });
      return false;
    }
    setState(() {
      _emailError = null;
    });
    return true;
  }

  bool get isEnabled {
    if (widget.initialEmail.isNotEmpty) return true;
    final text = emailController.text;
    if (text.isEmpty) return false;
    return text.contains(Util.emailRegEx);
  }
}
