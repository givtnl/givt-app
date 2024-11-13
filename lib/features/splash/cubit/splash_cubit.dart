import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SplashCubit extends CommonCubit<void, SplashCustom> {
  SplashCubit(
    this._authRepository,
    this._profilesRepository,
  ) : super(const BaseState.loading());

  final FamilyAuthRepository _authRepository;
  final ProfilesRepository _profilesRepository;

  Future<void> init() async {
    await _authRepository.initAuth();
    final user = _authRepository.getCurrentUser();
    final profiles = await _profilesRepository.refreshProfiles();

    if (user == null) {
      emitCustom(const SplashCustom.redirectToWelcome());
      return;
    }

    if (!user.personalInfoRegistered) {
      emitCustom(SplashCustom.redirectToSignup(user.email));
      return;
    }

    if (profiles.length <= 1) {
      emitCustom(const SplashCustom.redirectToAddMembers());
      return;
    }

    emitCustom(const SplashCustom.redirectToHome());
  }
}
