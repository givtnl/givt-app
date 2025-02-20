import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/set_a_goal_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/pages/gratitude_goal_commit_screen.dart';
import 'package:givt_app/features/family/helpers/datetime_extension.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
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
  late DateTime _byDate;
  int _index = 2;
  final List<SetAGoalOptions> _goalOptions = [
    SetAGoalOnceAWeek(),
    SetAGoalTwiceAWeek(),
    SetAGoalThriceAWeek(),
    SetAGoalFourTimesAWeek(),
    SetAGoalDaily(),
  ];

  @override
  void initState() {
    super.initState();
    setByDate();
  }

  void setByDate() {
    setState(() {
      _byDate = DateTime.now().add(
        Duration(
          days: 7 * _currentGoal().weeksToFormHabit,
        ),
      );
    });
  }

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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: FunCard(
                            backgroundColor: FamilyAppTheme.highlight99,
                            content: Column(
                              children: [
                                const Row(),
                                SvgPicture.asset(
                                  'assets/family/images/kids_without_frame.svg',
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TitleMediumText.primary30(
                                  'By ${_byDate.formattedFullMonth}',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                BodyMediumText(
                                  widget.behavior.weWillBeMoreLabel,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: FunTag.fromTag(
                            tag: _currentGoal().habitFormingTag,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    FunTag.fromTag(
                      tag: _currentGoal().weeksTag,
                    ),
                    const SizedBox(height: 4),
                    const BodyMediumText('Practicing gratitude'),
                    const SizedBox(height: 4),
                    HeadlineLargeText(
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
                          setByDate();
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                          AmplitudeEvents.continueClicked,
                          parameters: {
                            'page': 'Set a goal',
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
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
