import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'goal_tracker_state.dart';

class GoalTrackerCubit extends Cubit<GoalTrackerState> {
  GoalTrackerCubit() : super(const GoalTrackerState());

  void setGoal() {
    emit(state.copyWith(status: GoalTrackerStatus.noGoalSet));
    Future.delayed(const Duration(seconds: 2), () {
      emit(state.copyWith(status: GoalTrackerStatus.activeGoal));
    });
  }
}
