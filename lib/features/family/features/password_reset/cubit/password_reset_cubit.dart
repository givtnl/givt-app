import 'package:givt_app/features/family/features/password_reset/repositories/password_reset_repository.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class PasswordResetCubit extends CommonCubit<bool, dynamic> {
  PasswordResetCubit(
    this._passwordResetRepository,
  );

  final PasswordResetRepository _passwordResetRepository;

  @override
  void init() {
    emitInitial();
  }

  Future<void> resetPassword(
    String code,
    String email,
    String newPassword,
  ) async {
    emitLoading();
    try {
      final success = await _passwordResetRepository.resetPassword(
        code,
        email,
        newPassword,
      );
      if (success) {
        emitData(true);
      } else {
        emitError('Password reset failed');
      }
    } catch (e) {
      emitError('Password reset failed: ${e.toString()}');
    }
  }
}