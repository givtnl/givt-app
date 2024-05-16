import 'package:bloc/bloc.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_stripe_registration_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';

class GenerosityStripeRegistrationCubit extends Cubit<BaseState<Object>> {
  GenerosityStripeRegistrationCubit(this._authRepository)
      : super(const BaseState.loading());
  final AuthRepository _authRepository;

  void init() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final session = await _authRepository.refreshToken();
      final isAuthenticated = _authRepository.isAuthenticated();
      _openRegistration();
    } catch (e, s) {
      _openLogin();
    }
  }

  void _openRegistration() {
    emit(const BaseState.clear());
    emit(
      const BaseState.custom(
        GenerosityStripeRegistrationCustom.openStripeRegistration(),
      ),
    );
  }

  void _openLogin() {
    emit(const BaseState.clear());
    emit(
      const BaseState.custom(
        GenerosityStripeRegistrationCustom.openLoginPopup(),
      ),
    );
  }

  void onRegistrationFailed() {
    emit(const BaseState.clear());
    emit(
      const BaseState.custom(
        GenerosityStripeRegistrationCustom.showStripeNoFundsError(),
      ),
    );
  }

  void onRegistrationSuccess() {
    emit(const BaseState.clear());
    emit(
      const BaseState.custom(
        GenerosityStripeRegistrationCustom.stripeRegistrationSuccess(),
      ),
    );
  }

  void onClickRetry() => _openRegistration();

  void onLoggedIn() => _openRegistration();
}
