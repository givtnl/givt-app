part of 'goal_tracker_cubit.dart';

enum GoalTrackerStatus {
  initial,
  loading,
  noGoalSet,
  activeGoal,
  completedGoal,
  error
}

class GoalTrackerState extends Equatable {
  const GoalTrackerState({
    this.error = '',
    this.status = GoalTrackerStatus.initial,
  });

  final GoalTrackerStatus status;
  final String error;

  @override
  List<Object> get props => [status, error];

  GoalTrackerState copyWith({
    GoalTrackerStatus? status,
    String? error,
  }) {
    return GoalTrackerState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
