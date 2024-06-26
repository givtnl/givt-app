part of 'impact_groups_cubit.dart';

enum ImpactGroupCubitStatus { initial, loading, fetched, invited, error }

class ImpactGroupsState extends Equatable {
  const ImpactGroupsState({
    this.status = ImpactGroupCubitStatus.initial,
    this.error = '',
    this.groups = const [],
  });

  final ImpactGroupCubitStatus status;
  final String error;
  final List<ImpactGroup> groups;

  @override
  List<Object> get props => [status, error, groups, familyGoal];

  List<Goal> get goals => groups
      .where((element) => element.goal != const Goal.empty())
      .map((e) => e.goal)
      .toList();
  Goal get familyGoal => groups
      .firstWhere(
        (element) => element.type == ImpactGroupType.family,
        orElse: () => const ImpactGroup.empty(),
      )
      .goal;
  bool get hasGoals => goals.isNotEmpty;

  ImpactGroup getGoalGroup(Goal goal) =>
      groups.firstWhere((element) => element.goal.goalId == goal.goalId);

  ImpactGroupsState copyWith({
    ImpactGroupCubitStatus? status,
    String? error,
    List<ImpactGroup>? groups,
  }) {
    return ImpactGroupsState(
      status: status ?? this.status,
      error: error ?? this.error,
      groups: groups ?? this.groups,
    );
  }
}
