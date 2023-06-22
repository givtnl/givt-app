import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/app_version.dart';

class AboutGivtBottomSheet extends StatefulWidget {
  const AboutGivtBottomSheet({super.key});

  @override
  State<AboutGivtBottomSheet> createState() => _AboutGivtBottomSheetState();
}

class _AboutGivtBottomSheetState extends State<AboutGivtBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;
    final user = (context.read<AuthCubit>().state as AuthSuccess).user;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<InfraCubit, InfraState>(
              listener: (context, state) {
                if (state is InfraSuccess) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => WarningDialog(
                      title: locals.success,
                      content: locals.feedbackMailSent,
                      onConfirm: () => Navigator.of(context).pop(),
                    ),
                  ).whenComplete(() => Navigator.of(context).pop());
                }
                if (state is InfraFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(locals.somethingWentWrong),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: size.height * 0.03,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.country == 'US'
                            ? locals.informationAboutUsUs
                            : ['GB', 'GG', 'JE'].contains(user.country)
                                ? locals.informationAboutUsGb
                                : locals.informationAboutUs,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 20),
                      const AppVersion(),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Text(
                        locals.feedbackTitle,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        minLines: 10,
                        maxLines: 10,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: locals.typeMessage,
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                      const SizedBox(height: 20),
                      if (state is InfraLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: isEnabled
                              ? () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  await context
                                      .read<InfraCubit>()
                                      .contactSupport(
                                        message: _emailController.text,
                                        appLanguage: locals.localeName,
                                        email: user.email,
                                        guid: user.guid,
                                      );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: Text(
                            locals.send,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool get isEnabled => _emailController.text.isNotEmpty;
}
