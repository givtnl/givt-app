import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/pages/gratitude_goal_explanation_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GratitudeGoalSelectBehaviorScreen extends StatefulWidget {
  const GratitudeGoalSelectBehaviorScreen({super.key});

  @override
  State<GratitudeGoalSelectBehaviorScreen> createState() =>
      _GratitudeGoalSelectBehaviorScreenState();
}

class _GratitudeGoalSelectBehaviorScreenState
    extends State<GratitudeGoalSelectBehaviorScreen> {
  int? _pressedIndex;

  final List<BehaviorOptions> _behaviors = [
    SayingThankYou(),
    HavingAppreciation(),
    DealingWithEmotions(),
    WorkingTogether(),
  ];

  BehaviorOptions get _selectedBehavior => _behaviors[_pressedIndex!];

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: const EdgeInsets.symmetric(horizontal: 24),
      appBar: const FunTopAppBar(
        title: 'Gratitude goal',
        leading: kDebugMode ? GivtBackButtonFlat() : null,
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
                      const Spacer(),
                      const SizedBox(
                        height: 40,
                      ),
                      const TitleMediumText(
                        'For your family...\nWhat behavior would you like to work on?',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ...List.generate(
                        _behaviors.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FunTile(
                              shrink: true,
                              hasIcon: false,
                              mainAxisAlignment: MainAxisAlignment.center,
                              titleBig: _behaviors[index].behavior,
                              onTap: () {
                                setState(() {
                                  _pressedIndex = index;
                                });
                              },
                              backgroundColor: _pressedIndex == index
                                  ? FamilyAppTheme.primary98
                                  : FamilyAppTheme.highlight98,
                              borderColor: _pressedIndex == index
                                  ? FamilyAppTheme.primary80
                                  : FamilyAppTheme.highlight80,
                              textColor: _pressedIndex == index
                                  ? FamilyAppTheme.primary30
                                  : FamilyAppTheme.highlight40,
                              isPressedDown: _pressedIndex == index,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              analyticsEvent: AnalyticsEvent(
                                AmplitudeEvents.gratitudeGoalBehaviorClicked,
                                parameters: {
                                  'behavior': _behaviors[index].behavior,
                                },
                              ),
                              iconPath: '',
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    FunButton(
                      isDisabled: _pressedIndex == null,
                      text: 'Continue',
                      onTap: () {
                        Navigator.of(context).push(
                          GratitudeGoalExplanationScreen(
                            behavior: _selectedBehavior,
                          ).toRoute(context),
                        );
                      },
                      analyticsEvent: AnalyticsEvent(
                        AmplitudeEvents.gratitudeGoalContinueClicked,
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
