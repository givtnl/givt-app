import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/level_select_cubit.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/pages/generosity_hunt_level_introduction_page.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/widgets/level_tile.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';

class GenerosityHuntLevelsPage extends StatefulWidget {
  const GenerosityHuntLevelsPage({super.key});

  @override
  State<GenerosityHuntLevelsPage> createState() =>
      _GenerosityHuntLevelsPageState();
}

class _GenerosityHuntLevelsPageState extends State<GenerosityHuntLevelsPage> {
  final LevelSelectCubit cubit = getIt<LevelSelectCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userId = context.read<ProfilesCubit>().state.activeProfile.id;
    cubit.init(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar(
        title: 'Levels',
        leading: GivtBackButtonFlat(
          onPressed: () async => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: BaseStateConsumer(
          cubit: cubit,
          onCustom: (context, custom) {
            switch (custom) {
              case NavigateToLevelIntroduction():
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
            return ListView.separated(
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              itemCount: state.levels.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == state.levels.length) {
                  // Show "More levels coming soon" text after the last level
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: BodyMediumText(
                        'More levels coming soon',
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }

                final level = state.levels[index];
                return LevelTile(
                  level: level.level,
                  title: level.title,
                  subtitle: 'Level ${level.level}',
                  unlocked: level.isUnlocked,
                  completed: level.isCompleted,
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
