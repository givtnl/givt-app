import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/shared/bloc/base_state.dart';

class CommonCubit<T, S> extends Cubit<BaseState<T, S>> {
  CommonCubit(super.initialState);

  // no need to define equatable anymore
  // also fixes the problem where even if you use equatable
  // and there are no props it still wouldn't emit the state one after another
  void emitWithClear(BaseState<T, S> state) {
    emitClear();
    emit(state);
  }

  void emitClear() => emit(const BaseState.clear());

  void emitInitial() {
    emitWithClear(const BaseState.initial());
  }

  void emitLoading() {
    emitWithClear(const BaseState.loading());
  }

  void emitData(T data) {
    emitWithClear(BaseState.data(data));
  }

  void emitCustom(S custom) {
    emitWithClear(BaseState.custom(custom));
  }

  void emitError(String? message) {
    emitWithClear(BaseState.error(message));
  }

  void emitSnackbarMessage(String text, {bool isError = false}) {
    emitWithClear(BaseState.showSnackbarMessage(text: text, isError: isError));
  }

  // allows you to wrap logic in a try catch
  // without having to define the catch if it's non-important
  // also will automatically log exceptions in debug mode for easy development
  Future<void> inTryCatchFinally({
    required Future<void> Function() inTry,
    Future<void> Function(Object e, StackTrace? s)? inCatch,
    Future<void> Function()? inFinally,
  }) async {
    try {
      await inTry.call();
    } catch (e, s) {
      await inCatch?.call(e, s);
      if (kDebugMode) {
        LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      }
    } finally {
      await inFinally?.call();
    }
  }
}
