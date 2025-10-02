import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/reset_password/cubit/change_password_cubit.dart';
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

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    required this.code,
    required this.email,
    required this.isApp,
    super.key,
  });

  final String code;
  final String email;
  final bool isApp;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final ChangePasswordCubit _cubit = getIt<ChangePasswordCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void initState() {
    super.initState();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey.currentState?.validate();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar(
        title: context.l10n.passwordResetTitle,
        showBackButton: true,
        onBackPressed: () => context.pop(),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onInitial: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  TitleMediumText(
                    context.l10n.passwordResetTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  BodyMediumText(
                    context.l10n.passwordResetDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  OutlinedTextFormField(
                    controller: newPasswordController,
                    obscureText: _obscureNewPassword,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState!.validate();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.passwordRequired;
                      }
                      if (value.length < 6) {
                        return context.l10n.passwordTooShort;
                      }
                      return null;
                    },
                    hintText: context.l10n.newPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedTextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState!.validate();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.passwordRequired;
                      }
                      if (value != newPasswordController.text) {
                        return context.l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
                    hintText: context.l10n.confirmNewPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  FunButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        _cubit.changePassword(
                          userID: widget.email,
                          passwordToken: widget.code,
                          newPassword: newPasswordController.text,
                        );
                      }
                    },
                    text: context.l10n.changePassword,
                    analyticsEvent: AmplitudeEvents.changePasswordClicked.toEvent(),
                  ),
                ],
              ),
            ),
          );
        },
        onLoading: (context) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCircularProgressIndicator(),
                SizedBox(height: 16),
                BodyMediumText(
                  "We're processing your password change",
                ),
              ],
            ),
          );
        },
        onData: (context, data) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  primaryCircleWithIcon(
                    circleSize: 140,
                    iconData: FontAwesomeIcons.check,
                    iconSize: 48,
                  ),
                  const SizedBox(height: 24),
                  BodyMediumText(
                    context.l10n.passwordChangedSuccessfully,
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
                        // For app users, just close the page
                        context.pop();
                      } else {
                        // For web users, go to dashboard
                        context.go('/');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        onError: (context, message) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  errorCircleWithIcon(
                    circleSize: 140,
                    iconData: FontAwesomeIcons.triangleExclamation,
                    iconSize: 48,
                  ),
                  const SizedBox(height: 24),
                  BodyMediumText(
                    context.l10n.somethingWentWrong,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FunButton(
                    text: 'Ok',
                    analyticsEvent: AmplitudeEvents.okClicked.toEvent(),
                    onTap: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}