import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
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
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

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
        return FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: locals.changeEmail,
          content: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                OutlinedTextFormField(
                  controller: emailController,
                  onChanged: (_) => setState(() {}),
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
          primaryButton: FunButton(
            isDisabled: !isEnabled || isLoading,
            onTap: isEnabled && !isLoading
                ? () {
                    if (!formKey.currentState!.validate()) {
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

  bool get isEnabled {
    if (emailController.text == widget.email) return false;
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return emailController.text.isNotEmpty;
  }
}
