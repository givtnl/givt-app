import 'package:bloc/bloc.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/models/fun_bottom_sheet_with_async_action_state.dart';

class FunBottomSheetWithAsyncActionCubit
    extends Cubit<FunBottomSheetWithAsyncActionState> {
  FunBottomSheetWithAsyncActionCubit() : super(const InitialState());

  Future<void> doAsyncAction(Future<void> Function() asyncAction,
      {bool showGivtServerFailureMessage = false,
      bool showAnyErrorMessage = false}) async {
    emit(const LoadingState());
    try {
      await asyncAction();
      success();
    } on GivtServerFailure catch (e) {
      final errorMessage = e.body?['errorMessage'] as String?;
      error(errorMessage: showGivtServerFailureMessage ? errorMessage : null);
    } catch (e) {
      error(
        errorMessage: showAnyErrorMessage
            ? e.toString().replaceAll('Exception:', '')
            : null,
      );
    }
  }

  void onClose() => _emitInitialState();

  void success() {
    emit(const SuccessState());
  }

  void error({String? errorMessage}) {
    emit(ErrorState(errorMessage: errorMessage));
  }

  void onClickTryAgainAfterError() {
    _emitInitialState();
  }

  void _emitInitialState() {
    emit(const InitialState());
  }
}
