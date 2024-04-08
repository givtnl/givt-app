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
