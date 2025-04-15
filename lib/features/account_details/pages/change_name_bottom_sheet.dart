import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return BottomSheetLayout(
      title: Text(
        locals.changeName,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      child: BlocBuilder<PersonalInfoEditBloc, PersonalInfoEditState>(
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.05),
                CustomTextFormField(
                  controller: firstNameController,
                  onChanged: (value) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!Util.nameFieldsRegEx.hasMatch(value)) {
                      return '';
                    }
                    return null;
                  },
                  hintText: locals.firstName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  controller: lastNameController,
                  onChanged: (value) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!Util.nameFieldsRegEx.hasMatch(value)) {
                      return '';
                    }
                    return null;
                  },
                  hintText: locals.surname,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 15),
                Expanded(child: Container()),
                if (state.status == PersonalInfoEditStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: isEnabled
                        ? () {
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
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      locals.save,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
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
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        Util.nameFieldsRegEx.hasMatch(firstNameController.text) &&
        Util.nameFieldsRegEx.hasMatch(lastNameController.text);
  }
}
