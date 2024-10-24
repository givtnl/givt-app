import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/login/presentation/models/family_login_sheet_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyLoginCubit extends CommonCubit<String, FamilyLoginSheetCustom> {
  FamilyLoginCubit(
    this._authRepository,
  ) : super(const BaseState.initial());

  final FamilyAuthRepository _authRepository;

  void init(String? email) {
    emitInitial();

    if (email != null) {
      emitData(email);
      return;
    }

    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emitData(user.email);
      return;
    }

    // Should never happen, but just in case
    LoggingInfo.instance.error(
      'No email provided for login',
      methodName: 'FamilyLoginCubit.init',
    );
  }

  Future<void> login(String email, String password) async {
    emitLoading();

    try {
      await _authRepository.login(email, password);

      emitCustom(const FamilyLoginSheetCustom.successRedirect());
    } catch (e, stackTrace) {
      emitInitial();

      if (e.toString().contains('invalid_grant')) {
        LoggingInfo.instance.warning(
          e.toString(),
          methodName: stackTrace.toString(),
        );
        if (e.toString().contains('TwoAttemptsLeft')) {
          emitCustom(const FamilyLoginSheetCustom.showTwoAttemptsLeftDialog());
        }
        if (e.toString().contains('OneAttemptLeft')) {
          emitCustom(const FamilyLoginSheetCustom.showOneAttemptLeftDialog());
        }
        if (e.toString().contains('LockedOut')) {
          emitCustom(const FamilyLoginSheetCustom.showLockedOutDialog());
        }
      }

      emitCustom(const FamilyLoginSheetCustom.showFailureDialog());
    }
  }
}
