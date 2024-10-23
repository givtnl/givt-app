import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/login/presentation/models/family_login_sheet_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class FamilyLoginCubit extends CommonCubit<bool, FamilyLoginSheetCustom> {
  FamilyLoginCubit(
    this._authRepository,
  ) : super(const BaseState.initial());

  final FamilyAuthRepository _authRepository;

  void init() {
    emitInitial();
  }

  Future<bool> login(String email, String password) async {
    emitLoading();

    try {
      await _authRepository.login(email, password);
      return true;
    } catch (e, stackTrace) {
      if (e.toString().contains('invalid_grant')) {
        LoggingInfo.instance.warning(
          e.toString(),
          methodName: stackTrace.toString(),
        );
        if (e.toString().contains('TwoAttemptsLeft')) {
          emitCustom(const FamilyLoginSheetCustom.showTwoAttemptsLeftDialog());
          return false;
        }
        if (e.toString().contains('OneAttemptLeft')) {
          emitCustom(const FamilyLoginSheetCustom.showOneAttemptLeftDialog());
          return false;
        }
        if (e.toString().contains('LockedOut')) {
          emitCustom(const FamilyLoginSheetCustom.showLockedOutDialog());
          return false;
        }
      }

      emitCustom(const FamilyLoginSheetCustom.showFailureDialog());
      return false;
    }
  }
}
