import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
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
  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();
  final scrollController = ScrollController();
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
    final user = context.watch<AuthCubit>().state.user;
    return FunBottomSheet(
      title: locals.titleAboutGivt,
      closeAction: () => context.pop(),
      primaryButton: FunButton(
        isDisabled: !isEnabled,
        onTap: isEnabled
            ? () async {
                await widget.asyncCubit.doAsyncAction(
                  () async => context.read<InfraCubit>().contactSupport(
                        message: messageController.text,
                        appLanguage: locals.localeName,
                        email: user.email,
                        guid: user.guid,
                        metadata: null,
                      ),
                );
              }
            : null,
        text: locals.send,
        analyticsEvent: AnalyticsEventName.aboutGivtSendFeedbackClicked.toEvent(),
      ),
      content: SingleChildScrollView(
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
            FunInput(
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
    );
  }
}
