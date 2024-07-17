import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

class AboutGivtBottomSheet extends StatefulWidget {
  const AboutGivtBottomSheet({this.initialMessage = '', super.key,});

  final String initialMessage;

  @override
  State<AboutGivtBottomSheet> createState() => _AboutGivtBottomSheetState();
}

class _AboutGivtBottomSheetState extends State<AboutGivtBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();
  final scrollController = ScrollController();

  @override
  void initState() {
    messageController.text = widget.initialMessage;
    if (widget.initialMessage.isNotEmpty) {
      messageFocusNode.requestFocus();

      /// Ensure that the widget is rendered before scrolling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final user = context.read<AuthCubit>().state.user;
    const messageKey = GlobalObjectKey('messageKey');
    return BottomSheetLayout(
      title: Text(
        locals.titleAboutGivt,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
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
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: size.height * 0.03,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.country == Country.us.countryCode
                            ? locals.informationAboutUsUs
                            : Country.unitedKingdomCodes()
                                    .contains(user.country)
                                ? locals.informationAboutUsGb
                                : locals.informationAboutUs,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 20),
                      AppVersion(),
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
                        key: messageKey,
                        focusNode: messageFocusNode,
                        controller: messageController,
                        minLines: 10,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: locals.typeMessage,
                        ),
                        keyboardType: TextInputType.multiline,
                        onChanged: (_) => setState(() {}),
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
                                        message: messageController.text,
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  bool get isEnabled => messageController.text.isNotEmpty;
}
