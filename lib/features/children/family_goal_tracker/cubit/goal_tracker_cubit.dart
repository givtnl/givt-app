import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    emit(state.copyWith(status: GoalTrackerStatus.loading));

    try {
      final goals = await _goalTrackerRepository.fetchFamilyGoal();

      // No goals ever set
      if (goals.isEmpty) {
        emit(
          state.copyWith(status: GoalTrackerStatus.noGoalSet),
        );
        return;
      }

      // Sort goals by date created, latest first
      goals.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

      // Find the first goal that is not completed
      final current = goals.firstWhere(
        (element) => element.status == FamilyGoalStatus.inProgress,
        orElse: FamilyGoal.empty,
      );

      // There is an active goal
      if (current != const FamilyGoal.empty()) {
        final org = await _campaignRepository.getOrganisation(current.mediumId);
        emit(
          state.copyWith(
            currentGoal: current,
            organisation: org,
            goals: goals,
            status: GoalTrackerStatus.activeGoal,
          ),
        );
        return;
      }

      // No active goals, find the latest completed goal
      final latestCompleted = goals.firstWhere(
        (element) => element.status == FamilyGoalStatus.completed,
        orElse: FamilyGoal.empty,
      );
      // There is a completed goal
      if (latestCompleted != const FamilyGoal.empty()) {
        final org =
            await _campaignRepository.getOrganisation(latestCompleted.mediumId);
        emit(
          state.copyWith(
            currentGoal: latestCompleted,
            organisation: org,
            goals: goals,
            status: GoalTrackerStatus.completedGoal,
          ),
        );
        return;
      }

      // There are no active or completed goals, but goals list is not empty
      // In this case we still show no goal set in UI
      emit(
        state.copyWith(
          error: 'Something went wrong, we cannot find your goal',
          status: GoalTrackerStatus.error,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: "We couldn't fetch your goal\n$e",
          status: GoalTrackerStatus.error,
        ),
      );
    }
  }

  void clearGoal() {
    emit(
      state.copyWith(
        status: GoalTrackerStatus.noGoalSet,
        currentGoal: const FamilyGoal.empty(),
      ),
    );
  }
}
