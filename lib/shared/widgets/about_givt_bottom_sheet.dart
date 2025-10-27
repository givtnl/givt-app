import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class AboutGivtBottomSheet extends StatefulWidget {
  const AboutGivtBottomSheet({
    this.initialMessage = '',
    this.metadata,
    super.key,
  });

  final String initialMessage;
  final Map<String, String>? metadata;

  static void show(
    BuildContext context, {
    String initialMessage = '',
    Map<String, String>? metadata,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      builder: (_) => AboutGivtBottomSheet(
        initialMessage: initialMessage,
        metadata: metadata,
      ),
    );
  }

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
    final user = context.read<AuthCubit>().state.user;
    const messageKey = GlobalObjectKey('messageKey');

    return BlocConsumer<InfraCubit, InfraState>(
      listener: (context, state) {
        if (state is InfraSuccess) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: locals.success,
              content: locals.feedbackMailSent,
              onConfirm: () => context.pop(),
            ),
          ).whenComplete(() => context.pop());
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
        return FunBottomSheet(
          title: locals.titleAboutGivt,
          closeAction: () => context.pop(),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BodySmallText(
                    user.country == Country.us.countryCode
                        ? locals.informationAboutUsUs
                        : Country.unitedKingdomCodes().contains(user.country)
                            ? locals.informationAboutUsGb
                            : locals.informationAboutUs,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AppVersion(),
                  const SizedBox(height: 16),
                  TitleSmallText(
                    locals.feedbackTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedTextFormField(
                    key: messageKey,
                    focusNode: messageFocusNode,
                    controller: messageController,
                    minLines: 5,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    onChanged: (_) => setState(() {}),
                    smallFont: true,
                  ),
                ],
              ),
            ),
          ),
          icon: state is InfraLoading
              ? const CustomCircularProgressIndicator()
              : null,
          primaryButton: state is InfraLoading
              ? null // No button when loading
              : FunButton(
                  isDisabled: !isEnabled,
                  onTap: isEnabled
                      ? () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          await context.read<InfraCubit>().contactSupportSafely(
                                message: messageController.text,
                                appLanguage: locals.localeName,
                                email: user.email,
                                guid: user.guid,
                                metadata: widget.metadata,
                              );
                        }
                      : null,
                  text: locals.send,
                  analyticsEvent: AmplitudeEvents.onInfoRowClicked.toEvent(
                    parameters: {'action': 'send_feedback'},
                  ),
                ),
        );
      },
    );
  }

  bool get isEnabled => messageController.text.isNotEmpty;
}
