part of 'impact_groups_cubit.dart';

enum ImpactGroupsStatus {
  initial,
  loading,
  fetched,
  invited,
  inviteAccepted,
  error
}

class ImpactGroupsState extends Equatable {
  const ImpactGroupsState({
    this.status = ImpactGroupsStatus.initial,
    this.impactGroups = const [],
    this.invitedGroup = const ImpactGroup.empty(),
    this.error = '',
  });

  final ImpactGroupsStatus status;
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
    ImpactGroupsStatus? status,
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
