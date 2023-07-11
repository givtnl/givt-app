import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/util.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({
    this.email = '',
    super.key,
  });

  final String email;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthChangePasswordWrongEmail) {
                showDialog<void>(
                  context: context,
                  builder: (_) => WarningDialog(
                    title: context.l10n.requestFailed,
                    content: context.l10n.nonExistingEmail,
                    onConfirm: () => Navigator.of(context).pop(),
                  ),
                );
              }
              if (state is AuthChangePasswordSuccess) {
                showDialog<void>(
                  context: context,
                  builder: (_) => WarningDialog(
                    title: context.l10n.success,
                    content: context.l10n.resetPasswordSent,
                    onConfirm: () => Navigator.of(context).pop(),
                  ),
                ).whenComplete(() => Navigator.of(context).pop());
              }

              if (state is AuthChangePasswordFailure) {
                showDialog<void>(
                  context: context,
                  builder: (_) => WarningDialog(
                    title: context.l10n.requestFailed,
                    content: context.l10n.somethingWentWrong,
                    onConfirm: () => Navigator.of(context).pop(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    _buildTitleRow(locals, context),
                    const SizedBox(height: 20),
                    Text(
                      locals.forgotPasswordText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          formKey.currentState!.validate();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: locals.email,
                      ),
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
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.all(50),
                      child: Image.asset(
                        'assets/images/givy_question_big.png',
                        width: size.width * 0.3,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: isEnabled
                            ? () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                await context.read<AuthCubit>().changePassword(
                                      email: emailController.text,
                                    );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: Text(
                          locals.send,
                        ),
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool get isEnabled {
    if (widget.email.isNotEmpty) return true;
    if (formKey.currentState == null) return false;
    if (formKey.currentState!.validate() == false) return false;
    return emailController.text.isNotEmpty;
  }

  Row _buildTitleRow(
    AppLocalizations locals,
    BuildContext context,
  ) =>
      Row(
        children: [
          const BackButton(),
          Text(
            locals.changePassword,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      );
}
