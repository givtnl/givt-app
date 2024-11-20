import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/parent_summary_cubit.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/summary_conversation_list.dart';
import 'package:givt_app/features/family/helpers/datetime_extension.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class ParentSummaryScreen extends StatefulWidget {
  const ParentSummaryScreen({super.key});

  @override
  State<ParentSummaryScreen> createState() => _ParentSummaryScreenState();
}

class _ParentSummaryScreenState extends State<ParentSummaryScreen> {
  final ParentSummaryCubit _cubit = getIt<ParentSummaryCubit>();
  late AudioPlayer _player;
  bool _hasClickedAudio = false;

  @override
  void initState() {
    super.initState();
    _cubit.init();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      backgroundColor: FamilyAppTheme.secondary10,
      appBar: const FunTopAppBar(
        title: 'Summary',
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onData: (context, uiModel) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (uiModel?.date != null)
                  Container(
                    decoration: BoxDecoration(
                      color: FamilyAppTheme.highlight95,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LabelSmallText(
                      uiModel!.date!.formatDate(),
                      color: FamilyAppTheme.highlight40,
                    ),
                  ),
                if (uiModel?.date != null) const SizedBox(height: 12),
                const TitleMediumText(
                    'We’ve been working on our generosity superpowers!',
                    color: Colors.white),
                const SizedBox(height: 24),
                SummaryConversationList(
                  conversations: uiModel?.conversations ?? [],
                ),
                const SizedBox(height: 24),
                if (uiModel?.audioLink != null)
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _hasClickedAudio = true;
                      });
                      await _player.play(UrlSource(uiModel!.audioLink!));
                    },
                    child: const Text('Play audio'),
                  ),
                FunButton(
                  isDisabled: uiModel?.audioLink == null || !_hasClickedAudio,
                  text: 'Done',
                  onTap: () {
                    context.pop();
                  },
                  analyticsEvent: AnalyticsEvent(AmplitudeEvents
                      .coinMediumIdNotRecognizedGoBackHomeClicked),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
