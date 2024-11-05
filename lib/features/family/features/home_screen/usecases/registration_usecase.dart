import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/shared/models/user_ext.dart';

mixin class RegistrationUseCase {
  final AuthRepository _authRepository = getIt<AuthRepository>();

  Future<bool> userNeedsToFillInPersonalDetails() async {
    try {
      UserExt? userExternal;
      final (userExt, session, amountPresets) =
          await _authRepository.isAuthenticated() ?? (null, null, null);
      userExternal = userExt;
      return userExternal?.personalInfoRegistered == false;
    } catch (e) {
      return false;
    }
  }
}
