sealed class BaseState<T, S> {
  const BaseState();

  const factory BaseState.initial() = InitialState;

  const factory BaseState.loading() = LoadingState;

  const factory BaseState.data(T data) = DataState;

  const factory BaseState.custom(S custom) = CustomState;

  const factory BaseState.showSnackbarMessage({
    required String text,
    bool isError,
  }) = SnackbarState;

  const factory BaseState.clear() = ClearState;
}

// Cubits do not emit a duplicate state one after another,
// so if you want to show the same pop-up twice
// (ie. users keeps pressing send when a required field isn't entered)
// you need to emit the ClearState first before emitting the same state again
class ClearState<T, S> extends BaseState<T, S> {
  const ClearState();
}

class InitialState<T, S> extends BaseState<T, S> {
  const InitialState();
}

class LoadingState<T, S> extends BaseState<T, S> {
  const LoadingState();
}

class DataState<T, S> extends BaseState<T, S> {
  const DataState(this.data);

  final T data;
}

class CustomState<T, S> extends BaseState<T, S> {
  const CustomState(this.custom);

  final S custom;
}

class SnackbarState<T, S> extends BaseState<T, S> {
  const SnackbarState({required this.text, this.isError = false});

  final String text;
  final bool isError;
}
