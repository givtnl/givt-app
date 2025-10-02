import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/password_reset/cubit/password_reset_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_medium_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({
    required this.code,
    required this.email,
    required this.isApp,
    super.key,
  });

  final String code;
  final String email;
  final bool isApp;

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final PasswordResetCubit _cubit = getIt<PasswordResetCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey.currentState?.validate();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar(
        title: context.l10n.changePassword,
        showBackButton: !widget.isApp,
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onInitial: (context) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  TitleMediumText(
                    context.l10n.passwordResetTitle,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  BodyMediumText(
                    context.l10n.passwordResetDescription,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 32),
                  OutlinedTextFormField(
                    controller: passwordController,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState!.validate();
                      });
                    },
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.passwordRequired;
                      }
                      if (value.length < 8) {
                        return context.l10n.passwordTooShort;
                      }
                      return null;
                    },
                    hintText: context.l10n.newPassword,
                  ),
                  const SizedBox(height: 16),
                  OutlinedTextFormField(
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState!.validate();
                      });
                    },
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.confirmPasswordRequired;
                      }
                      if (value != passwordController.text) {
                        return context.l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
                    hintText: context.l10n.confirmNewPassword,
                  ),
                  const Spacer(),
                  FunButton(
                    onTap: isEnabled
                        ? () {
                            _cubit.resetPassword(
                              widget.code,
                              widget.email,
                              passwordController.text,
                            );
                          }
                        : null,
                    text: context.l10n.changePassword,
                    analyticsEvent: AmplitudeEvents.changePasswordClicked.toEvent(),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
        onLoading: (context) {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        },
        onData: (context, data) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                primaryCircleWithIcon(
                  circleSize: 140,
                  iconData: FontAwesomeIcons.check,
                  iconSize: 48,
                ),
                const SizedBox(height: 24),
                TitleMediumText(
                  context.l10n.passwordResetSuccess,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                BodyMediumText(
                  context.l10n.passwordResetSuccessDescription,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (!widget.isApp) ...[
                  FunButton(
                    text: context.l10n.goToDashboard,
                    analyticsEvent: AmplitudeEvents.okClicked.toEvent(),
                    onTap: () {
                      // Navigate to dashboard
                      context.go('/');
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                FunButton(
                  text: context.l10n.buttonDone,
                  analyticsEvent: AmplitudeEvents.okClicked.toEvent(),
                  onTap: () {
                    if (widget.isApp) {
                      // Close the app or navigate back to app
                      Navigator.of(context).pop();
                    } else {
                      context.go('/');
                    }
                  },
                ),
              ],
            ),
          );
        },
        onError: (context, message) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                errorCircleWithIcon(
                  circleSize: 140,
                  iconData: FontAwesomeIcons.triangleExclamation,
                  iconSize: 48,
                ),
                const SizedBox(height: 24),
                TitleMediumText(
                  context.l10n.passwordResetError,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                BodyMediumText(
                  context.l10n.passwordResetErrorDescription,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FunButton(
                  text: context.l10n.tryAgain,
                  analyticsEvent: AmplitudeEvents.okClicked.toEvent(),
                  onTap: () {
                    _cubit.init();
                  },
                ),
                const SizedBox(height: 16),
                FunButton(
                  text: context.l10n.buttonDone,
                  analyticsEvent: AmplitudeEvents.okClicked.toEvent(),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }
}