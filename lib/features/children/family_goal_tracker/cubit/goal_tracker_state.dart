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
    this.currentGoal = const FamilyGoal.empty(),
    this.goals = const [],
    this.organisation = const Organisation.empty(),
  });

  final GoalTrackerStatus status;
  final String error;
  final List<FamilyGoal> goals;
  final FamilyGoal currentGoal;
  final Organisation organisation;

  @override
  List<Object> get props => [status, error, goals, currentGoal, organisation];

  GoalTrackerState copyWith({
    GoalTrackerStatus? status,
    String? error,
    List<FamilyGoal>? goals,
    FamilyGoal? currentGoal,
    Organisation? organisation,
  }) {
    return GoalTrackerState(
      status: status ?? this.status,
      error: error ?? this.error,
      goals: goals ?? this.goals,
      currentGoal: currentGoal ?? this.currentGoal,
      organisation: organisation ?? this.organisation,
    );
  }
}
