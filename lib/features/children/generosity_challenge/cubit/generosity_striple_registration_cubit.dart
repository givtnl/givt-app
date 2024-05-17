import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_stripe_registration_custom.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/utils/chat_script_registration_handler.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityStripeRegistrationCubit extends Cubit<BaseState<Object>> {
  GenerosityStripeRegistrationCubit(
      this._authRepository, this._sharedPreferences, this._apiService)
      : super(const BaseState.loading());
  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final APIService _apiService;

  void init() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _updateUrlsAndCountry();
    try {
      try {
        await _authRepository.updateFingerprintCertificate();
      } catch (e, s) {
        print("test");
      }
      final stripeIntent = await _authRepository.fetchStripeSetupIntent();
      _openRegistration();
    } catch (e, s) {
      _openLogin();
    }
  }

  void _updateUrlsAndCountry() {
    const baseUrl = String.fromEnvironment('API_URL_US');
    const baseUrlAWS = String.fromEnvironment('API_URL_AWS_US');

    _apiService.updateApiUrl(baseUrl, baseUrlAWS);

    unawaited(
      _sharedPreferences.setString(
        Util.countryIso,
        Country.us.countryCode,
      ),
    );
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
