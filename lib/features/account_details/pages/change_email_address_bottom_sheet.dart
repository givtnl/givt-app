import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_sheet_success.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/util.dart';

class ChangeEmailAddressBottomSheet extends StatefulWidget {
  const ChangeEmailAddressBottomSheet({
    required this.email,
    super.key,
  });

  final String email;

  @override
  State<ChangeEmailAddressBottomSheet> createState() =>
      _ChangeEmailAddressBottomSheetState();
}

class _ChangeEmailAddressBottomSheetState
    extends State<ChangeEmailAddressBottomSheet> {
  final TextEditingController emailController = TextEditingController();
  String? _emailError;

  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
      builder: (context, state) {
        final isLoading = state.status == PersonalInfoEditStatus.loading;
        final isEmailChangeSuccess =
            state.status == PersonalInfoEditStatus.emailChangeSuccess;

        if (isEmailChangeSuccess) {
          return FunBottomSheet(
            closeAction: () => _onEmailChangeSuccessDone(context),
            title: locals.success,
            content: FunIcon.checkmark(),
            primaryButton: FunButton(
              text: locals.buttonDone,
              onTap: () => _onEmailChangeSuccessDone(context),
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.editEmailSaveClicked,
                parameters: {
                  'old_email': widget.email,
                  'new_email': emailController.text,
                },
              ),
            ),
          );
        }

        return FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: locals.changeEmail,
          content: Column(
            children: [
              const SizedBox(height: 24),
              FunInput(
                controller: emailController,
                hintText: locals.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.go,
                errorText: _emailError,
                onChanged: (_) {
                  setState(() {
                    _emailError = null;
                  });
                },
              ),
            ],
          ),
          primaryButton: FunButton(
            isDisabled: !isEnabled || isLoading,
            onTap: isEnabled && !isLoading
                ? () {
                    if (!_validateEmail(locals.invalidEmail)) {
                      return;
                    }
                    context.read<PersonalInfoEditBloc>().add(
                      PersonalInfoEditEmail(
                        email: emailController.text,
                      ),
                    );
                  }
                : null,
            text: isLoading ? locals.loadingTitle : locals.save,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.editEmailSaveClicked,
              parameters: {
                'old_email': widget.email,
                'new_email': emailController.text,
              },
            ),
          ),
        );
      },
    );
  }

  void _onEmailChangeSuccessDone(BuildContext context) {
    completePersonalInfoEditSheet(context);
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
    final text = emailController.text;
    if (text == widget.email) return false;
    if (text.isEmpty) return false;
    return text.contains(Util.emailRegEx);
  }
}
