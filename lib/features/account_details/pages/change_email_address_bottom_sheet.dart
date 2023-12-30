import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return BottomSheetLayout(
      title: Text(
        locals.changeEmail,
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
                                  PersonalInfoEditEmail(
                                    email: emailController.text,
                                  ),
                                );
                          }
                        : null,
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
    return emailController.text.isNotEmpty;
  }
}
