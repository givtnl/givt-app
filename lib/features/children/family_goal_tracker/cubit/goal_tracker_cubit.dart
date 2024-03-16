import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/family_goal_tracker/model/family_goal.dart';
import 'package:givt_app/features/children/family_goal_tracker/repository/goal_tracker_repository.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';

part 'goal_tracker_state.dart';

class GoalTrackerCubit extends Cubit<GoalTrackerState> {
  GoalTrackerCubit(
    this._goalTrackerRepository,
    this._campaignRepository,
  ) : super(const GoalTrackerState());
  final GoalTrackerRepository _goalTrackerRepository;
  final CampaignRepository _campaignRepository;

  Future<void> getGoal() async {
    try {
      final goal = await _goalTrackerRepository.fetchFamilyGoal();

      if (goal == const FamilyGoal.empty()) {
        emit(state.copyWith(status: GoalTrackerStatus.noGoalSet));
        return;
      }

      final organisation =
          await _campaignRepository.getOrganisation(goal.mediumId);
      emit(
        state.copyWith(
          activeGoal: goal,
          organisation: organisation,
          status: GoalTrackerStatus.activeGoal,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          status: GoalTrackerStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void clearGoal() {
    emit(
      state.copyWith(
        status: GoalTrackerStatus.noGoalSet,
        activeGoal: const FamilyGoal.empty(),
      ),
    );
  }
}
