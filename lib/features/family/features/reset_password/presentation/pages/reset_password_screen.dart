import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/reset_password/cubit/reset_password_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/util.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    this.initialEmail = '',
    super.key,
  });

  final String initialEmail;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();

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

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  final _cubit = getIt<ResetPasswordCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onInitial: (context) {
        return FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: context.l10n.changePassword,
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  OutlinedTextFormField(
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState!.validate();
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.invalidEmail;
                      }
                      if (value.contains(Util.emailRegEx) == false) {
                        return context.l10n.invalidEmail;
                      }
                      return null;
                    },
                    hintText: context.l10n.email,
                  ),
                  const SizedBox(height: 24),
                  BodyMediumText(
                    context.l10n.forgotPasswordText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/givy_question_big.png',
                    width: 120,
                  ),
                ],
              ),
            ),
          ),
          primaryButton: FunButton(
            onTap: () {
              _cubit.resetPassword(emailController.text);
            },
            text: context.l10n.changePassword,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.changePasswordClicked,
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
            text: 'Done',
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.okClicked,
            ),
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
            analyticsEvent:
                AnalyticsEvent(AmplitudeEvents.okClicked),
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

  bool get isEnabled {
    if (widget.initialEmail.isNotEmpty) return true;
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return emailController.text.isNotEmpty;
  }
}
