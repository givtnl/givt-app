sealed class BaseState<T> {
  const BaseState();

  const factory BaseState.initial() = InitialState;

  const factory BaseState.loading() = LoadingState;

  const factory BaseState.data(T data) = DataState;

  const factory BaseState.custom(dynamic custom) = CustomState;

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
class ClearState<T> extends BaseState<T> {
  const ClearState();
}

class InitialState<T> extends BaseState<T> {
  const InitialState();
}

class LoadingState<T> extends BaseState<T> {
  const LoadingState();
}

class DataState<T> extends BaseState<T> {
  const DataState(this.data);

  final T data;
}

class CustomState<T> extends BaseState<T> {
  const CustomState(this.custom);

  final dynamic custom;
}

class SnackbarState<T> extends BaseState<T> {
  const SnackbarState({required this.text, this.isError = false});

  final String text;
  final bool isError;
}
