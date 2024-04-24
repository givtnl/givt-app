part of 'impact_groups_cubit.dart';

enum ImpactGroupCubitStatus { initial, loading, fetched, invited, error }

class ImpactGroupsState extends Equatable {
  const ImpactGroupsState({
    this.status = ImpactGroupCubitStatus.initial,
    this.impactGroups = const [],
    this.invitedGroup = const ImpactGroup.empty(),
    this.error = '',
  });

  final ImpactGroupCubitStatus status;
  final List<ImpactGroup> impactGroups;
  final ImpactGroup invitedGroup;
  final String error;

  List<Goal> get goals => impactGroups
      .where((element) => element.goal != const Goal.empty())
      .map((e) => e.goal)
      .toList();
  Goal get familyGoal => impactGroups
      .firstWhere(
        (element) => element.type == ImpactGroupType.family,
        orElse: () => const ImpactGroup.empty(),
      )
      .goal;
  bool get hasGoals => goals.isNotEmpty;

  ImpactGroup getGoalGroup(Goal goal) =>
      impactGroups.firstWhere((element) => element.goal.id == goal.id);

  @override
  List<Object> get props => [
        status,
        impactGroups,
        invitedGroup,
        error,
      ];

  ImpactGroupsState copyWith({
    ImpactGroupCubitStatus? status,
    List<ImpactGroup>? impactGroups,
    ImpactGroup? invitedGroup,
    String? error,
  }) {
    return ImpactGroupsState(
      status: status ?? this.status,
      impactGroups: impactGroups ?? this.impactGroups,
      invitedGroup: invitedGroup ?? this.invitedGroup,
      error: error ?? this.error,
    );
  }
}
