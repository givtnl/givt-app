part of 'goal_tracker_cubit.dart';

enum GoalTrackerStatus { initial, noGoalSet, activeGoal, completedGoal, error }

class GoalTrackerState extends Equatable {
  const GoalTrackerState({
    this.error = '',
    this.status = GoalTrackerStatus.initial,
    this.activeGoal = const FamilyGoal.empty(),
    this.organisation = const Organisation.empty(),
  });

  final GoalTrackerStatus status;
  final String error;
  final FamilyGoal activeGoal;
  final Organisation organisation;

  @override
  List<Object> get props => [status, error, activeGoal, organisation];

  GoalTrackerState copyWith({
    GoalTrackerStatus? status,
    String? error,
    FamilyGoal? activeGoal,
    Organisation? organisation,
  }) {
    return GoalTrackerState(
      status: status ?? this.status,
      error: error ?? this.error,
      activeGoal: activeGoal ?? this.activeGoal,
      organisation: organisation ?? this.organisation,
    );
  }
}
