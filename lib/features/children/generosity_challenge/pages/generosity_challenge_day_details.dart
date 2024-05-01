import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/daily_assignment_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/dialogs/feedback_banner_dialog.dart';
import 'package:givt_app/features/children/generosity_challenge/models/day.dart';
import 'package:givt_app/features/children/generosity_challenge/models/task.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_content_helper.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_challenge_daily_card.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';

class GenerosityChallengeDayDetails extends StatelessWidget {
  const GenerosityChallengeDayDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.read<GenerosityChallengeCubit>();
    final task = GenerosityChallengeContentHelper.getTaskByIndex(
      challenge.state.detailedDayIndex,
    );
    final day = challenge.state.days[challenge.state.detailedDayIndex];
    final isDualCard = task.partnerCard != null;
    return BlocProvider(
      create: (context) => DailyAssignmentCubit(),
      child: BlocBuilder<DailyAssignmentCubit, DailyAssignmentState>(
        builder: (context, state) {
          final assignment = context.read<DailyAssignmentCubit>();
          return Scaffold(
            appBar: GenerosityAppBar(
              title: 'Day ${challenge.state.detailedDayIndex + 1}',
              leading: BackButton(
                onPressed: challenge.overview,
                color: AppTheme.givtGreen40,
              ),
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.givtGreen40,
                                  fontFamily: 'Rouna',
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ),
                if (!isDualCard ||
                    state.status == DailyAssignmentStatus.confirm ||
                    state.status == DailyAssignmentStatus.completed ||
                    day.isCompleted)
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
                      await challenge.completeActiveDay();
                      assignment.complete();
                    },
                    text: 'Complete',
                    isDisabled: day.isCompleted,
                    leftIcon: FontAwesomeIcons.solidSquareCheck,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(DailyAssignmentState state, Task task, Day day) {
    final isDualCard = task.partnerCard != null;

    if (isDualCard &&
        (state.status == DailyAssignmentStatus.confirm ||
            state.status == DailyAssignmentStatus.completed)) {
      return GenerosityDailyCard(
        task: task.partnerCard!,
        isCompleted: day.isCompleted,
        dynamicDescription: state.dynamicDescription ??
            'Something went wrong,\nplease contact support via\nsupport@givtapp.net',
      );
    }
    return GenerosityDailyCard(
      task: task,
      isCompleted: day.isCompleted,
    );
  }
}
