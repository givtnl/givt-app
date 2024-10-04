import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/shared/models/user_ext.dart';

mixin class RegistrationUseCase {
  final AuthRepository _authRepository = getIt<AuthRepository>();

  Future<bool> userNeedsRegistration() async {
    try {
      final (userExt, session, amountPresets) =
          await _authRepository.isAuthenticated();
      return userExt?.needRegistration ?? false;
    } catch (e, s) {
      // TODO: Consider logging the error or handling specific exceptions
      return false;
    }
  }
}
