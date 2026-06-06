import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_sheet_success.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/util.dart';

class ChangeNameBottomSheet extends StatefulWidget {
  const ChangeNameBottomSheet({
    required this.firstName,
    required this.lastName,
    super.key,
  });

  final String firstName;
  final String lastName;

  @override
  State<ChangeNameBottomSheet> createState() => _ChangeNameBottomSheetState();
}

class _ChangeNameBottomSheetState extends State<ChangeNameBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
      builder: (context, state) {
        final isLoading = state.status == PersonalInfoEditStatus.loading;
        final isSuccess = state.status == PersonalInfoEditStatus.success;

        if (isSuccess) {
          return FunBottomSheet(
            closeAction: () => completePersonalInfoEditSheet(context),
            title: locals.success,
            content: FunIcon.checkmark(),
            primaryButton: FunButton(
              text: locals.buttonDone,
              onTap: () => completePersonalInfoEditSheet(context),
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.changeNameSubmitted,
              ),
            ),
          );
        }

        return FunBottomSheet(
          closeAction: () => Navigator.of(context).pop(),
          title: locals.changeName,
          content: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                InputFormField(
                  controller: firstNameController,
                  label: locals.firstName,
                  hintText: locals.firstName,
                  textCapitalization: TextCapitalization.sentences,
                  validator: _nameValidator,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                InputFormField(
                  controller: lastNameController,
                  label: locals.surname,
                  hintText: locals.surname,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  validator: _nameValidator,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          primaryButton: FunButton(
            isDisabled: !isEnabled || isLoading,
            onTap: isEnabled && !isLoading ? _onSave : null,
            text: isLoading ? locals.loadingTitle : locals.save,
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.changeNameSubmitted,
            ),
          ),
        );
      },
    );
  }

  void _onSave() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    context.read<PersonalInfoEditBloc>().add(
          PersonalInfoEditName(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
          ),
        );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty || !Util.nameFieldsRegEx.hasMatch(value)) {
      return '';
    }
    return null;
  }

  bool get isEnabled {
    if (formKey.currentState == null) return false;
    if (!formKey.currentState!.validate()) return false;

    final isNameDifferent = firstNameController.text != widget.firstName ||
        lastNameController.text != widget.lastName;

    return isNameDifferent;
  }
}
