part of 'topup_cubit.dart';

sealed class TopupState {
  const TopupState();
}

class InitialState extends TopupState {
  const InitialState();
}

class SuccessState extends TopupState {
  const SuccessState(this.amount, this.recurring);

  final int amount;
  final bool recurring;
}

class LoadingState extends TopupState {
  const LoadingState();
}

class ErrorState extends TopupState {
  const ErrorState();
}
