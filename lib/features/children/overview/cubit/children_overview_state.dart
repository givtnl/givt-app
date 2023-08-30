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
  });

  final List<Profile> profiles;

  @override
  List<Object> get props => [profiles];
}

class ChildrenOverviewErrorState extends ChildrenOverviewState {
  const ChildrenOverviewErrorState({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
