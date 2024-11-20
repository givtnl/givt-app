import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/parent_summary_cubit.dart';
import 'package:givt_app/features/family/features/gratitude-summary/presentation/widgets/summary_conversation_list';
import 'package:givt_app/features/family/helpers/datetime_extension.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class ParentSummaryScreen extends StatefulWidget {
  const ParentSummaryScreen({super.key});

  @override
  State<ParentSummaryScreen> createState() => _ParentSummaryScreenState();
}

class _ParentSummaryScreenState extends State<ParentSummaryScreen> {
  final ParentSummaryCubit _cubit = getIt<ParentSummaryCubit>();
  late AudioPlayer _player;
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
                  LabelMediumText(uiModel!.date!.formatDate()),
                SummaryConversationList(
                  conversations: uiModel?.conversations ?? [],
                ),
                if (uiModel?.audioLink != null)
                  GestureDetector(
                    onTap: () async {
                      await _player.play(UrlSource(uiModel!.audioLink!));
                    },
                    child: const Text('Play audio'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
