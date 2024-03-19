import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/family_goal_tracker/model/family_goal.dart';
import 'package:givt_app/features/children/family_goal_tracker/repository/goal_tracker_repository.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';

part 'goal_tracker_state.dart';

class GoalTrackerCubit extends Cubit<GoalTrackerState> {
  GoalTrackerCubit(
    this._goalTrackerRepository,
    this._campaignRepository,
    this._authCubit,
  ) : super(const GoalTrackerState()) {
    _authCubit.stream.listen((event) {
      if (event.status == AuthStatus.authenticated) {
        getGoal();
      }
    });
  }
  final GoalTrackerRepository _goalTrackerRepository;
  final CampaignRepository _campaignRepository;

  final AuthCubit _authCubit;

  Future<void> getGoal() async {
    try {
      final goal = await _goalTrackerRepository.fetchFamilyGoal();

      if (goal == const FamilyGoal.empty()) {
        emit(
          state.copyWith(
            activeGoal: const FamilyGoal.empty(),
            status: GoalTrackerStatus.noGoalSet,
          ),
        );
        return;
      }

      final organisation =
          await _campaignRepository.getOrganisation(goal.mediumId);
      emit(
        state.copyWith(
          activeGoal: goal,
          organisation: organisation,
          status: goal.status == FamilyGoalStatus.completed
              ? GoalTrackerStatus.completedGoal
              : GoalTrackerStatus.activeGoal,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          error: e.toString(),
          status: GoalTrackerStatus.error,
        ),
      );
    }
  }

  void clearGoal() {
    emit(
      state.copyWith(
        activeGoal: const FamilyGoal.empty(),
        status: GoalTrackerStatus.initial,
      ),
    );
  }
}
