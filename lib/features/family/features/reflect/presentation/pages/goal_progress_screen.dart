import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/league/presentation/pages/in_game_league_screen.dart';
import 'package:givt_app/features/family/features/reflect/bloc/goal_progress_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class GoalProgressScreen extends StatefulWidget {
  const GoalProgressScreen({super.key});

  @override
  State<GoalProgressScreen> createState() => _GoalProgressScreenState();
}

class _GoalProgressScreenState extends State<GoalProgressScreen> {
  final GoalProgressCubit _cubit = getIt<GoalProgressCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      canPop: false,
      body: BaseStateConsumer(
        cubit: _cubit,
        onLoading: (context) => const CustomCircularProgressIndicator(),
        onData: (context, uiModel) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              TitleMediumText(
                uiModel.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FunProgressbar.gratitudeGoal(
                key: const ValueKey('Daily-Experience-Progressbar'),
                currentProgress: uiModel.currentProgress,
                total: uiModel.goal,
                suffix: context.l10n.progressbarPlayed,
              ),
              const Spacer(),
              Visibility(
                visible: uiModel.showButton,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: FunButton(
                  onTap: () {
                    Navigator.of(context)
                        .push(const InGameLeagueScreen().toRoute(context));
                  },
                  text: "We're committed",
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.reflectAndShareWereCommitted,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
