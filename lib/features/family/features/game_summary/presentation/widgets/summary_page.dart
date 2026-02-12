import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_player.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/summary_conversation_list.dart';
import 'package:givt_app/features/family/helpers/helpers.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({required this.uiModel, super.key});
  final SummaryUIModel uiModel;
  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _hasClickedAudio = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.uiModel.date != null)
          FunTag(
            variant: FunTagVariant.highlight,
            text: widget.uiModel.date!.formattedFullMonth,
          ),
        if (widget.uiModel.date != null) const SizedBox(height: 12),
        const TitleMediumText(
            'We’ve been working on our generosity superpowers!',
            textAlign: TextAlign.center,
            color: Colors.white),
        const SizedBox(height: 24),
        Expanded(
          child: SummaryConversationList(
            conversations: widget.uiModel.conversations,
          ),
        ),
        const SizedBox(height: 24),
        if (widget.uiModel.audioLink != null)
          FunAudioPlayer(
            source: widget.uiModel.audioLink!,
            showDeleteButton: false,
            isUrl: true,
            onPlayExtension: () {
              setState(() {
                _hasClickedAudio = true;
              });
            },
          ),
        FunButton(
          isDisabled: widget.uiModel.audioLink != null && !_hasClickedAudio,
          text: context.l10n.buttonDone,
          onTap: () => context.pop(),
          analyticsEvent: AmplitudeEvents.afterGameSummaryDoneClicked.toEvent(),
        ),
      ],
    );
  }
}
