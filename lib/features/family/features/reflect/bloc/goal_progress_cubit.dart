import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/goal_progress_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GoalProgressCubit extends CommonCubit<GoalProgressUIModel, void> {
  GoalProgressCubit(this._reflectAndShareRepository)
      : super(const BaseState.loading());

  final ReflectAndShareRepository _reflectAndShareRepository;

  void init() {
    fetchGameStats();
  }

  void fetchGameStats() {
    _reflectAndShareRepository.getGameStats().then((gameStats) {
      // Title based on if goal is achieved
      var title = "You're on a roll";
      if (gameStats.gratitudeGoalCurrent == gameStats.gratitudeGoal) {
        title = 'Awesome! Goal achieved';
      }

      // Set the current progress to one less than the current progress, to update it in 1000ms
      emitData(
        GoalProgressUIModel(
          currentProgress: gameStats.gratitudeGoalCurrent - 1,
          goal: gameStats.gratitudeGoal,
          title: title,
          showButton: false,
        ),
      );

      Future.delayed(const Duration(milliseconds: 1000), () {
        emitData(
          GoalProgressUIModel(
            currentProgress: gameStats.gratitudeGoalCurrent,
            goal: gameStats.gratitudeGoal,
            title: title,
            showButton: true,
          ),
        );
      });
    });
  }
}
