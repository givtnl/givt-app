import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/dialogs/feedback_banner_dialog.dart';
import 'package:givt_app/features/children/generosity_challenge/models/day.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_content_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_challenge_daily_card.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';

class GenerosityChallengeDayDetails extends StatelessWidget {
  const GenerosityChallengeDayDetails({
    required this.isDebug,
    super.key,
  });
  final bool isDebug;

  @override
  Widget build(BuildContext context) {
    final challenge = context.watch<GenerosityChallengeCubit>();
    final task = GenerosityChallengeContentHelper.getTaskByIndex(
      challenge.state.detailedDayIndex,
      isDebugQuickFlowEnabled: challenge.state.isDebugQuickFlowEnabled,
    );
    final day = challenge.state.days[challenge.state.detailedDayIndex];
    final isSingleCard = task.partnerCard == null;
    final isLastDay = challenge.state.islastDay;
    final isDailyAssignmentConfirm = challenge.state.status ==
        GenerosityChallengeStatus.dailyAssigmentConfirm;
    final isDayCompleted = day.isCompleted;
    // We do NOT show the 'Complete' button if:
    // - the challenge is on the last day
    // We show the 'Complete' button if:
    // - it is a single card task (day 3- 6)
    // - the day is already completed (disabled state)
    // - the status is dailyAssigmentConfirm (happens for dual cards day 2/7)
    final shouldShowCompleteButton = !isLastDay &
        (isSingleCard || isDailyAssignmentConfirm || isDayCompleted);

    return BlocBuilder<GenerosityChallengeCubit, GenerosityChallengeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: GenerosityAppBar(
            title: 'Day ${challenge.state.detailedDayIndex + 1}',
            leading: GenerosityBackButton(onPressed: challenge.overview),
          ),
          body: SafeArea(child: _buildCard(state, task, day)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (day.isCompleted &&
                  challenge.state.isLastCompleted &&
                  !challenge.state.hasActiveDay)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: TextButton.icon(
                    onPressed: () {
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents
                            .generosityChallengeDayUndoCompleting,
                        eventProperties: {
                          'day': challenge.state.detailedDayIndex + 1,
                        },
                      );
                      challenge
                          .undoCompletedDay(challenge.state.detailedDayIndex);
                    },
                    icon: const Icon(
                      FontAwesomeIcons.rotateLeft,
                      size: 20,
                      color: AppTheme.givtGreen40,
                    ),
                    label: Text(
                      'Undo completing',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.givtGreen40,
                            fontFamily: 'Rouna',
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              if (shouldShowCompleteButton)
                GivtElevatedButton(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.25),
                      builder: (context) => FeedbackBannerDialog(task: task),
                    );

                    await AnalyticsHelper.logEvent(
                      eventName:
                          AmplitudeEvents.generosityChallengeDayCompleted,
                      eventProperties: {
                        'day': challenge.state.detailedDayIndex + 1,
                      },
                    );
                    await challenge.completeActiveDay(isDebug);
                  },
                  text: 'Complete',
                  isDisabled: day.isCompleted,
                  leftIcon: FontAwesomeIcons.solidSquareCheck,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(GenerosityChallengeState state, Task task, Day day) {
    final isDualCard = task.partnerCard != null;

    if (isDualCard &&
        state.status == GenerosityChallengeStatus.dailyAssigmentConfirm) {
      return GenerosityDailyCard(
        task: task.partnerCard!,
        isCompleted: day.isCompleted,
        dynamicDescription: state.assignmentDynamicDescription ??
            'Something went wrong,\nplease contact support via\nsupport@givtapp.net',
      );
    }
    return GenerosityDailyCard(
      task: task,
      isCompleted: day.isCompleted,
      isLastDay: state.islastDay,
    );
  }
}
