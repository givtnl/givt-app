import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/set_a_goal_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/pages/gratitude_goal_commit_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeGoalSetAGoalScreen extends StatefulWidget {
  const GratitudeGoalSetAGoalScreen({required this.behavior, super.key});

  final BehaviorOptions behavior;

  @override
  State<GratitudeGoalSetAGoalScreen> createState() =>
      _GratitudeGoalSetAGoalScreenState();
}

class _GratitudeGoalSetAGoalScreenState
    extends State<GratitudeGoalSetAGoalScreen> {
  int _index = 2;
  final List<SetAGoalOptions> _goalOptions = [
    SetAGoalOnceAWeek(),
    SetAGoalTwiceAWeek(),
    SetAGoalThriceAWeek(),
    SetAGoalFourTimesAWeek(),
    SetAGoalDaily(),
  ];

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: const EdgeInsets.symmetric(horizontal: 24),
      appBar: const FunTopAppBar(
        title: 'Set a goal',
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
                      FunTag.secondary(
                        text: '${_currentGoal().weeksToFormHabit} weeks',
                      ),
                      const SizedBox(height: 4),
                      const BodyMediumText('Practicing gratitude'),
                      const SizedBox(height: 4),
                      TitleMediumText(
                        _currentGoal().timesAWeekLabel,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SliderTheme(
                        data: FunSliderTheme.getSliderTheme(context),
                        child: Slider(
                          max: _goalOptions.length - 1,
                          divisions: _goalOptions.length - 1,
                          value: _index.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              _index = value.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    FunButton(
                      text: 'Continue',
                      onTap: () => Navigator.of(context).push(
                        GratitudeGoalCommitScreen(
                          chosenOption: _currentGoal(),
                          behavior: widget.behavior,
                        ).toRoute(context),
                      ),
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.gratitudeGoalSetAGoalContinueClicked,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SetAGoalOptions _currentGoal() => _goalOptions[_index];
}
