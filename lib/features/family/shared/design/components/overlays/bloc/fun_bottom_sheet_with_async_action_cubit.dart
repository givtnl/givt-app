import 'package:bloc/bloc.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/models/fun_bottom_sheet_with_async_action_state.dart';

class FunBottomSheetWithAsyncActionCubit
    extends Cubit<FunBottomSheetWithAsyncActionState> {
  FunBottomSheetWithAsyncActionCubit() : super(const InitialState());

  Future<void> doAsyncAction(Future<void> Function() asyncAction) async {
    emit(const LoadingState());
    try {
      await asyncAction();
      success();
    } catch (e) {
      error();
    }
  }

  void onClose() => _emitInitialState();

  void success() {
    emit(const SuccessState());
  }

  void error() {
    emit(const ErrorState());
  }

  void onClickTryAgainAfterError() {
    _emitInitialState();
  }

  void _emitInitialState() {
    emit(const InitialState());
  }
}
