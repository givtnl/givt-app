import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
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

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return FunBottomSheet(
      title: locals.changeEmail,
      primaryButton: FunButton(
        isDisabled: !isEnabled,
        onTap: isEnabled
            ? () {
                if (!formKey.currentState!.validate()) {
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
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.editEmailSaveClicked,
          parameters: {
            'old_email': widget.email,
            'new_email': emailController.text,
          },
        ),
      ),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: size.height * 0.05),
            CustomTextFormField(
              controller: emailController,
              onChanged: (value) => setState(() {}),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.contains(Util.emailRegEx) == false) {
                  return locals.invalidEmail;
                }
                return null;
              },
              hintText: locals.email,
              textInputAction: TextInputAction.go,
            ),
          ],
        ),
      ),
    );
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return emailController.text.isNotEmpty;
  }
}
