part of 'child_details_cubit.dart';

sealed class ChildDetailsState extends Equatable {
  const ChildDetailsState();

  @override
  List<Object> get props => [];
}

final class ChildDetailsInitialState extends ChildDetailsState {
  const ChildDetailsInitialState();
}

final class ChildDetailsFetchingState extends ChildDetailsState {
  const ChildDetailsFetchingState();
}

final class ChildDetailsErrorState extends ChildDetailsState {
  const ChildDetailsErrorState({
    required this.errorMessage,
  });

  final String errorMessage;
}

final class ChildDetailsFetchedState extends ChildDetailsState {
  const ChildDetailsFetchedState({
    required this.profileDetails,
  });

  final ProfileExt profileDetails;
}
