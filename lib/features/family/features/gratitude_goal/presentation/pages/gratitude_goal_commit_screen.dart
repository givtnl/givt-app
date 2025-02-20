import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/gratitude_goal/bloc/gratitude_goal_commit_cubit.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/behavior_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/domain/models/set_a_goal_options.dart';
import 'package:givt_app/features/family/features/gratitude_goal/presentation/models/gratitude_goal_commit_custom.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_tag.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

class GratitudeGoalCommitScreen extends StatefulWidget {
  const GratitudeGoalCommitScreen(
      {required this.chosenOption, required this.behavior, super.key});

  final SetAGoalOptions chosenOption;
  final BehaviorOptions behavior;

  @override
  State<GratitudeGoalCommitScreen> createState() =>
      _GratitudeGoalCommitScreenState();
}

class _GratitudeGoalCommitScreenState extends State<GratitudeGoalCommitScreen> {
  final GratitudeGoalCommitCubit _cubit = getIt<GratitudeGoalCommitCubit>();

  bool _isButtonLoading = false;

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      appBar: const FunTopAppBar(
        title: 'Build a habit',
        leading: GivtBackButtonFlat(),
      ),
      body: BaseStateConsumer(
        cubit: _cubit,
        onCustom: _onCustom,
        onData: (context, uiModel) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    if (uiModel != null)
                      AvatarBar(
                        uiModel: uiModel,
                      ),
                    if (uiModel != null)
                      const SizedBox(
                        height: 40,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TitleSmallText(
                        widget.behavior.weWantToBeLabel,
                        textAlign: TextAlign.center,
                      ),
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
                      text: '${widget.chosenOption.weeksToFormHabit} weeks',
                    ),
                    const SizedBox(height: 4),
                    HeadlineLargeText(
                      widget.chosenOption.timesAWeekLabel,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 24),
                      FunButton(
                        isLoading: _isButtonLoading,
                        text: 'Commit to this goal',
                        onTap: () {
                          _cubit.onTapCommitToThisGoal(
                            widget.chosenOption,
                            widget.behavior,
                          );
                          setState(() {
                            _isButtonLoading = true;
                          });
                        },
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents
                              .gratitudeGoalCommitToThisGoalClicked,
                          parameters: {
                            'weeksToFormHabit':
                                widget.chosenOption.weeksToFormHabit,
                            'timesAWeek': widget.chosenOption.timesAWeek,
                            'timesAWeekLabel':
                                widget.chosenOption.timesAWeekLabel,
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onCustom(BuildContext context, GratitudeGoalCommitCustom custom) {
    switch (custom) {
      case final SetButtonLoading event:
        setState(() {
          _isButtonLoading = event.isLoading;
        });
      case NavigateToHome():
        context.goNamed(FamilyPages.profileSelection.name);
    }
  }
}
