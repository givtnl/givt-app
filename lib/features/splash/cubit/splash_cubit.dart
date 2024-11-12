import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SplashCubit extends CommonCubit<void, SplashCustom> {
  SplashCubit(
    FamilyAuthRepository authRepository,
  )   : _authRepository = authRepository,
        super(const BaseState.loading());

  final FamilyAuthRepository _authRepository;

  Future<void> init() async {
    await _authRepository.initAuth();
    final user = _authRepository.getCurrentUser();

    if (user == null) {
      emitCustom(const SplashCustom.redirectToWelcome());
      return;
    }

    if (user.tempUser || !user.personalInfoRegistered) {
      emitCustom(SplashCustom.redirectToSignup(user.email));
      return;
    }

    emitCustom(const SplashCustom.redirectToHome());
  }
}
