import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/fun_audio_player.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/summary_conversation_list.dart';
import 'package:givt_app/features/family/helpers/helpers.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key, required this.uiModel});
  final SummaryUIModel uiModel;
  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _hasClickedAudio = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.uiModel.date != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
            decoration: BoxDecoration(
              color: FamilyAppTheme.highlight95,
              borderRadius: BorderRadius.circular(24),
            ),
            child: LabelSmallText(
              widget.uiModel.date!.formatDate(),
              textAlign: TextAlign.center,
              color: FamilyAppTheme.highlight40,
            ),
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
          text: 'Done',
          onTap: () => context.pop(),
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.afterGameSummaryDoneClicked,
          ),
        ),
      ],
    );
  }
}
