
sealed class FunBottomSheetWithAsyncActionState {
  const FunBottomSheetWithAsyncActionState();
}

class InitialState extends FunBottomSheetWithAsyncActionState {
  const InitialState();
}

class SuccessState extends FunBottomSheetWithAsyncActionState {
  const SuccessState();
}

class LoadingState extends FunBottomSheetWithAsyncActionState {
  const LoadingState();
}

class ErrorState extends FunBottomSheetWithAsyncActionState {
  const ErrorState({this.errorMessage});

  final String? errorMessage;
}
