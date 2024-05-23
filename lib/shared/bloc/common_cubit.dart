import 'package:bloc/bloc.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/shared/bloc/base_state.dart';

class CommonCubit<T> extends Cubit<BaseState<T>> {
  CommonCubit(super.initialState);

  void emitWithClear(BaseState<T> state) {
    emit(const BaseState.clear());
    emit(state);
  }

  void emitInitial() {
    emitWithClear(const BaseState.initial());
  }

  void emitLoading() {
    emitWithClear(const BaseState.loading());
  }

  void emitData(T data) {
    emitWithClear(BaseState.data(data));
  }

  void emitCustom(dynamic custom) {
    emitWithClear(BaseState.custom(custom));
  }

  void emitSnackbarMessage(String text, {bool isError = false}) {
    emitWithClear(BaseState.showSnackbarMessage(text: text, isError: isError));
  }

  Future<void> inTryCatchFinally({
    required Future<void> Function() inTry,
    Future<void> Function(Object e, StackTrace? s)? inCatch,
    Future<void> Function()? inFinally,
  }) async {
    try {
      await inTry.call();
    } catch (e, s) {
      await inCatch?.call(e, s);
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    } finally {
      await inFinally?.call();
    }
  }
}
