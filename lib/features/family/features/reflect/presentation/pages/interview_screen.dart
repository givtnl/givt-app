import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/gratitude-summary/bloc/record_cubit.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/gratitude_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/record_answer_screen.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_bubble.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final InterviewCubit _cubit = getIt<InterviewCubit>();
  final RecordCubit _recordCubit = getIt<RecordCubit>();
  final ReflectAndShareRepository _repository =
      getIt<ReflectAndShareRepository>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onInitial: (context) => const SizedBox.shrink(),
      onLoading: (context) => FunScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_repository.isAITurnedOn())
              FunBubble.captainAi(
                text: 'One moment! Even superheroes need a second to think!',
              ),
            if (_repository.isAITurnedOn()) const SizedBox(height: 24),
            const Center(child: CustomCircularProgressIndicator()),
          ],
        ),
      ),
      onCustom: handleCustom,
      onData: (context, uiModel) {
        switch (uiModel) {
          case PassThePhoneUIModel():
            return PassThePhone(
              user: uiModel.reporter,
              audioPath: 'family/audio/pass_phone_to_next_reporter.wav',
              customBtnText: 'Show question',
              onTap: (BuildContext context) {
                _cubit.onShowQuestionClicked();
              },
            );
          case RecordAnswerUIModel():
            return RecordAnswerScreen(
              uiModel: uiModel,
            );
        }
      },
    );
  }

  void handleCustom(BuildContext context, InterviewCustom custom) {
    switch (custom) {
      case final PassThePhoneToSidekick data:
        Navigator.pushReplacement(
          context,
          PassThePhone.toSidekick(data.profile).toRoute(context),
        );
      case final GratitudeSelection data:
        Navigator.of(context).pushReplacement(
          GratitudeSelectionScreen(reporter: data.reporter).toRoute(context),
        );
      case ResetTimer():
        break;
      case StartRecording():
        _recordCubit.start();
    }
  }
}
