import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/reset_password/repositories/reset_password_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class ResetPasswordCubit extends CommonCubit<bool, dynamic> {
  ResetPasswordCubit(
    this._resetPasswordRepository,
  ) : super(const BaseState.initial());

  final ResetPasswordRepository _resetPasswordRepository;

  void init() {
    emitInitial();
  }

  Future<void> resetPassword(String email) async {
    emitLoading();

    try {
      await _resetPasswordRepository.resetPassword(email);
      emitData(true);
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );

      emitError(null);
    }
  }
}
