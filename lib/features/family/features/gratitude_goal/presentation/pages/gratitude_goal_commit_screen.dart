import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/set_a_goal_options.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class GratitudeGoalCommitScreen extends StatelessWidget {
  const GratitudeGoalCommitScreen(
      {required this.chosenOption, required this.behavior, super.key});

  final SetAGoalOptions chosenOption;
  final BehaviorOptions behavior;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: const EdgeInsets.symmetric(horizontal: 24),
      appBar: const FunTopAppBar(
        title: 'Build a habit',
        leading: GivtBackButtonFlat(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      //TODO avatars
                      const SizedBox(
                        height: 24,
                      ),
                      TitleSmallText(
                        behavior.weWantToBeLabel,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Image.asset(
                        'assets/family/images/gratitude_goal_happy.png',
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const BodyMediumText('Practice gratitude'),
                      const SizedBox(height: 4),
                      FunTag.secondary(
                        text: '${chosenOption.weeksToFormHabit} weeks',
                      ),
                      const SizedBox(height: 4),
                      TitleMediumText(
                        chosenOption.timesAWeekLabel,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    FunButton(
                      text: 'Commit to this goal',
                      onTap: () =>
                          context.goNamed(FamilyPages.profileSelection.name),
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.gratitudeGoalCommitToThisGoalClicked,
                        parameters: {
                          'weeksToFormHabit': chosenOption.weeksToFormHabit,
                          'timesAWeek': chosenOption.timesAWeek,
                          'timesAWeekLabel': chosenOption.timesAWeekLabel,
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
