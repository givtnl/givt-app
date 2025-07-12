import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/pages/generosity_hunt_level_introduction_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_mission_card.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/fun_mission_card_ui_model.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_uimodel.dart';

class GenerosityHuntLevelsPage extends StatelessWidget {
  const GenerosityHuntLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = LevelSelectCubit(getIt());

    return BaseStateConsumer(
      cubit: cubit,
      onInitial: (context) {
        return Scaffold(
          appBar: FunTopAppBar(
            title: 'Levels',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _LevelTile(
                  level: 1,
                  title: 'Scan it!',
                  subtitle: 'Level 1',
                  unlocked: true,
                  onTap: () => cubit.selectLevel(1),
                ),
                const SizedBox(height: 8),
                _LevelTile(
                  level: 2,
                  title: 'Collect it!',
                  subtitle: 'Level 2',
                  unlocked: false,
                  onTap: () => cubit.selectLevel(2),
                ),
                const SizedBox(height: 8),
                _LevelTile(
                  level: 3,
                  title: '5 of a kind',
                  subtitle: 'Level 3',
                  unlocked: false,
                  onTap: () => cubit.selectLevel(3),
                ),
                const SizedBox(height: 8),
                _LevelTile(
                  level: 4,
                  title: 'Health challenge',
                  subtitle: 'Level 4',
                  unlocked: false,
                  onTap: () => cubit.selectLevel(4),
                ),
                const SizedBox(height: 8),
                _LevelTile(
                  level: 5,
                  title: 'Breakfast streak',
                  subtitle: 'Level 5',
                  unlocked: false,
                  onTap: () => cubit.selectLevel(5),
                ),
              ],
            ),
          ),
        );
      },
      onCustom: (context, custom) {
        if (custom is NavigateToLevelIntroduction) {
          Navigator.of(context).push(
            const GenerosityHuntLevelIntroductionPage().toRoute(context),
          );
        }
      },
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.level,
    required this.title,
    required this.subtitle,
    this.unlocked = false,
    this.onTap,
  });

  final int level;
  final String title;
  final String subtitle;
  final bool unlocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FunMissionCard(
      uiModel: FunMissionCardUIModel(
        title: title,
        description: subtitle,
        headerIcon: !unlocked ? FunIcon.lock(iconSize: 24) : null,
        progress: unlocked
            ? GoalCardProgressUImodel(
                amount: 0,
                goalAmount: 1,
              )
            : null,
        disabled: !unlocked,
      ),
      onTap: unlocked ? onTap : null,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents
            .debugButtonClicked, // TODO: Use a more specific event if available
      ),
    );
  }
}
