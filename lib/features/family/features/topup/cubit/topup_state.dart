part of 'topup_cubit.dart';

sealed class TopupState {
  const TopupState(this.userGuid, this.amount, this.recurring);

  final String userGuid;
  final int amount;
  final bool recurring;
}

class InitialState extends TopupState {
  const InitialState(super.userGuid, super.amount, super.recurring);
}

class SuccessState<T> extends TopupState {
  const SuccessState(super.userGuid, super.amount, super.recurring);
}

class LoadingState extends TopupState {
  const LoadingState(super.userGuid, super.amount, super.recurring);
}

class ErrorState extends TopupState {
  const ErrorState(this.userGuid, this.amount, this.recurring, this.message)
      : super(userGuid, amount, recurring);

  final String userGuid;
  final int amount;
  final bool recurring;
  final String message;
}
