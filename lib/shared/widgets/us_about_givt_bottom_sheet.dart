import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class USAboutGivtBottomSheet extends StatefulWidget {
  const USAboutGivtBottomSheet({
    required this.asyncCubit,
    this.initialMessage = '',
    super.key,
  });

  final FunBottomSheetWithAsyncActionCubit asyncCubit;
  final String initialMessage;

  @override
  State<USAboutGivtBottomSheet> createState() => _USAboutGivtBottomSheetState();
}

class _USAboutGivtBottomSheetState extends State<USAboutGivtBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();
  final scrollController = ScrollController();
  final FamilyAuthCubit _familyAuthCubit = getIt<FamilyAuthCubit>();
  late bool isEnabled;

  @override
  void initState() {
    isEnabled = widget.initialMessage.isNotEmpty;
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

    const messageKey = GlobalObjectKey('messageKey');
    final user = _familyAuthCubit.user;
    return FunBottomSheet(
      title: locals.titleAboutGivt,
      closeAction: () => context.pop(),
      primaryButton: FunButton(
        isDisabled: !isEnabled,
        onTap: isEnabled
            ? () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                await widget.asyncCubit.doAsyncAction(
                  () async => context.read<InfraCubit>().contactSupport(
                        message: messageController.text,
                        appLanguage: locals.localeName,
                        email: user!.email,
                        guid: user.guid,
                        metadata: null,
                      ),
                );
              }
            : null,
        text: locals.send,
        analyticsEvent: AmplitudeEvents.aboutGivtSendFeedbackClicked.toEvent(),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/logo.png',
                width: 140,
              ),
              const SizedBox(height: 24),
              const BodySmallText(
                'Givt is a product of Givt Inc.\n\nWe are located on 12 N Cheyanne Ave, #305Tulsa, OK. For questions or complaints you can reach us via +1 918-615-9611 or support@givt.app',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AppVersion(),
              const SizedBox(height: 32),
              Row(
                children: [
                  TitleSmallText(
                    locals.feedbackTitle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OutlinedTextFormField(
                key: messageKey,
                minLines: 3,
                maxLines: 3,
                focusNode: messageFocusNode,
                controller: messageController,
                hintText: locals.typeMessage,
                keyboardType: TextInputType.multiline,
                onChanged: (text) => setState(() {
                  isEnabled = text.isNotEmpty;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
