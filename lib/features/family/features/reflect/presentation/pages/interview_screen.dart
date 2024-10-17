import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/gratitude_selection_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/record_answer_screen.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final InterviewCubit _cubit = getIt<InterviewCubit>();

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
      onCustom: handleCustom,
      onData: (context, uiModel) {
        switch (uiModel) {
          case PassThePhoneUIModel():
            return PassThePhone(
              user: uiModel.reporter,
              customBtnText: 'Show question',
              onTap: (BuildContext context) => _cubit.onShowQuestionClicked(),
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
    }
  }
}
