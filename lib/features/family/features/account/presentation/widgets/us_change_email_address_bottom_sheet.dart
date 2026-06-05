import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/util.dart';

class USChangeEmailAddressBottomSheet extends StatefulWidget {
  const USChangeEmailAddressBottomSheet({
    required this.email,
    required this.asyncCubit,
    super.key,
  });

  final String email;
  final FunBottomSheetWithAsyncActionCubit asyncCubit;

  @override
  State<USChangeEmailAddressBottomSheet> createState() =>
      _ChangeEmailAddressBottomSheetState();
}

class _ChangeEmailAddressBottomSheetState
    extends State<USChangeEmailAddressBottomSheet> {
  final FamilyAuthRepository _familyAuthRepository =
      getIt<FamilyAuthRepository>();

  final TextEditingController emailController = TextEditingController();
  String? _emailError;

  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      closeAction: () => Navigator.of(context).pop(),
      title: locals.changeEmail,
      primaryButton: FunButton(
        isDisabled: !isEnabled,
        onTap: isEnabled
            ? () {
                if (!_validateEmail(locals.invalidEmail)) {
                  return;
                }
                widget.asyncCubit.doAsyncAction(
                  () => _familyAuthRepository.updateEmail(
                    emailController.text,
                  ),
                  showGivtServerFailureMessage: true,
                  showAnyErrorMessage: true,
                );
              }
            : null,
        text: locals.save,
        analyticsEvent: AnalyticsEventName.editEmailSaveClicked.toEvent(
          parameters: {
            'old_email': widget.email,
            'new_email': emailController.text,
          },
        ),
      ),
      content: Column(
        children: [
          const SizedBox(height: 24),
          FunInput(
            controller: emailController,
            hintText: locals.email,
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
    final text = emailController.text;
    if (text == widget.email) return false;
    if (text.isEmpty) return false;
    return text.contains(Util.emailRegEx);
  }
}
