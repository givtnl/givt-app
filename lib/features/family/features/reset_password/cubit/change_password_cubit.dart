import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/reset_password/repositories/change_password_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class ChangePasswordCubit extends CommonCubit<bool, dynamic> {
  ChangePasswordCubit(
    this._changePasswordRepository,
  ) : super(const BaseState.initial());

  final ChangePasswordRepository _changePasswordRepository;

  void init() {
    emitInitial();
  }

  Future<void> changePassword({
    required String userID,
    required String passwordToken,
    required String newPassword,
  }) async {
    emitLoading();

    try {
      await _changePasswordRepository.changePassword(
        userID: userID,
        passwordToken: passwordToken,
        newPassword: newPassword,
      );
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