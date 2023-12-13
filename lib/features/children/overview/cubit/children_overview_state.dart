part of 'children_overview_cubit.dart';

sealed class ChildrenOverviewState extends Equatable {
  const ChildrenOverviewState();

  @override
  List<Object> get props => [];
}

class ChildrenOverviewInitialState extends ChildrenOverviewState {
  const ChildrenOverviewInitialState();
}

class ChildrenOverviewLoadingState extends ChildrenOverviewState {
  const ChildrenOverviewLoadingState();
}

class ChildrenOverviewUpdatedState extends ChildrenOverviewState {
  const ChildrenOverviewUpdatedState({
    required this.profiles,
    required this.displayAllowanceInfo,
  });

  final List<Profile> profiles;
  final bool displayAllowanceInfo;

  @override
  List<Object> get props => [profiles, displayAllowanceInfo];
}

class ChildrenOverviewErrorState extends ChildrenOverviewState {
  const ChildrenOverviewErrorState({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
