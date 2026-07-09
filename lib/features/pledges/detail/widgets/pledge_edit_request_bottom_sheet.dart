import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/pledges/detail/cubit/pledge_detail_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class PledgeEditRequestBottomSheet extends StatefulWidget {
  const PledgeEditRequestBottomSheet({
    required this.uiModel,
    required this.prefilledText,
    super.key,
  });

  final PledgeDetailUIModel uiModel;
  final String prefilledText;

  static void show(
    BuildContext context, {
    required PledgeDetailUIModel uiModel,
  }) {
    final prefilledText = context.l10n.pledgesEditRequestPrefilledText;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      builder: (_) => PledgeEditRequestBottomSheet(
        uiModel: uiModel,
        prefilledText: prefilledText,
      ),
    );
  }

  @override
  State<PledgeEditRequestBottomSheet> createState() =>
      _PledgeEditRequestBottomSheetState();
}

class _PledgeEditRequestBottomSheetState
    extends State<PledgeEditRequestBottomSheet> {
  final messageController = TextEditingController();
  final messageFocusNode = FocusNode();
  var _showSuccess = false;

  @override
  void initState() {
    super.initState();
    messageController.text = widget.prefilledText;
    messageFocusNode.requestFocus();
  }

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  Map<String, String> _buildMetadata() {
    final group = widget.uiModel.group;
    final goalSummaries = group.goals
        .map(
          (goal) =>
              '${goal.goalName}: ${goal.totalAmount} ${goal.type}'
              '${goal.frequency == null ? '' : ', ${goal.frequency}'}'
              ' (${goal.transactions.length} scheduled)',
        )
        .join('; ');

    return {
      'Flow': 'Pledges',
      'Pledge group ID': group.pledgeGroupId,
      'Campaign': group.pledgeGroupName,
      'Goals': goalSummaries,
    };
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;

    if (_showSuccess) {
      return FunBottomSheet(
        title: locals.pledgesEditRequestSuccessTitle,
        content: FunIcon.checkmark(),
        primaryButton: FunButton(
          text: locals.buttonDone,
          onTap: () => context.pop(),
          analyticsEvent: AnalyticsEventName.bottomsheet.toEvent(
            parameters: {
              'bottomsheet_name': 'pledge_edit_request',
              'action': 'success_done_clicked',
            },
          ),
        ),
      );
    }

    return BlocConsumer<InfraCubit, InfraState>(
      listener: (context, state) {
        if (state is InfraSuccess) {
          setState(() => _showSuccess = true);
        }
        if (state is InfraFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(locals.somethingWentWrong)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is InfraLoading;
        final isEnabled = messageController.text.trim().isNotEmpty;

        return FunBottomSheet(
          title: locals.pledgesEditRequestTitle,
          closeAction: () => context.pop(),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BodyMediumText(locals.pledgesEditRequestBody),
              const SizedBox(height: 16),
              FunInput(
                focusNode: messageFocusNode,
                controller: messageController,
                hintText: '',
                minLines: 5,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          icon: isLoading ? const CustomCircularProgressIndicator() : null,
          primaryButton: isLoading
              ? null
              : FunButton(
                  isDisabled: !isEnabled,
                  onTap: isEnabled
                      ? () async {
                          await context.read<InfraCubit>().contactSupportSafely(
                                message:
                                    'Pledge change request:\n${messageController.text.trim()}',
                                appLanguage: locals.localeName,
                                email: user.email,
                                guid: user.guid,
                                subject: 'Pledge change request',
                                metadata: _buildMetadata(),
                              );
                        }
                      : null,
                  text: locals.pledgesEditRequestSendButton,
                  analyticsEvent:
                      AnalyticsEventName.pledgesEditRequestSendClicked.toEvent(),
                ),
        );
      },
    );
  }
}
