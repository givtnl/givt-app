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

final class ChildTupUpFundsErrorState extends ChildDetailsState {
  const ChildTupUpFundsErrorState();
}

final class ChildDetailsErrorState extends ChildDetailsState {
  const ChildDetailsErrorState({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

final class ChildDetailsFetchedState extends ChildDetailsState {
  const ChildDetailsFetchedState({
    required this.profileDetails,
  });

  final ProfileExt profileDetails;

  @override
  List<Object> get props => [profileDetails];
}

final class ChildEditGivingAllowanceSuccessState extends ChildDetailsState {
  const ChildEditGivingAllowanceSuccessState({
    required this.allowance,
  });

  final int allowance;

  @override
  List<Object> get props => [allowance];
}

final class ChildTopUpSuccessState extends ChildDetailsState {
  const ChildTopUpSuccessState({
    required this.amount,
  });

  final int amount;

  @override
  List<Object> get props => [amount];
}
