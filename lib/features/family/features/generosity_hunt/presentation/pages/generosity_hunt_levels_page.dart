import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/pages/generosity_hunt_level_introduction_page.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/widgets/level_tile.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class GenerosityHuntLevelsPage extends StatelessWidget {
  const GenerosityHuntLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<LevelSelectCubit>();

    return Scaffold(
      appBar: FunTopAppBar(
        title: 'Levels',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: BaseStateConsumer(
          cubit: cubit,
          onCustom: (context, custom) {
            if (custom is NavigateToLevelIntroduction) {
              Navigator.of(context).push(
                const GenerosityHuntLevelIntroductionPage().toRoute(context),
              );
            }
          },
          onInitial: (context) => const Center(
            child: CustomCircularProgressIndicator(),
          ),
          onLoading: (context) => const Center(
            child: CustomCircularProgressIndicator(),
          ),
          onData: (context, state) {
            if (state.levels.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              itemCount: state.levels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final level = state.levels[index];
                return LevelTile(
                  level: level.level,
                  title: level.title,
                  subtitle: 'Level ${level.level}',
                  unlocked: index == 0,
                  onTap: () => cubit.selectLevel(level.level),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
