import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_stripe_registration_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityStripeRegistrationCubit extends Cubit<BaseState<Object>> {
  GenerosityStripeRegistrationCubit(
      this._authRepository, this._sharedPreferences, this._apiService)
      : super(const BaseState.loading()) {
    print("test");
  }

  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final APIService _apiService;

  // normally this would not be needed but
  // the stripe page resets the flutter lifecycle
  bool _hasInitBeenCalled = false;

  void init() {
    if (_hasInitBeenCalled) return;
    _hasInitBeenCalled = true;
    _setupRegistration();
  }

  Future<void> _setupRegistration() async {
    _updateUrlsAndCountry();
    try {
      try {
        await _authRepository.updateFingerprintCertificate();
      } catch (e, s) {
        unawaited(
          LoggingInfo.instance.info(
            e.toString(),
            methodName: s.toString(),
          ),
        );
      }
      final stripeResponse = await _authRepository.fetchStripeSetupIntent();
      _openRegistration(stripeResponse);
    } catch (e, s) {
      _showSetupError();
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

  void _openRegistration(StripeResponse stripeResponse) {
    emit(const BaseState.clear());
    emit(
      BaseState.custom(
        GenerosityStripeRegistrationCustom.openStripeRegistration(
            stripeResponse),
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

  void _showSetupError() {
    emit(const BaseState.clear());
    emit(
      const BaseState.custom(
        GenerosityStripeRegistrationCustom.showSetupError(),
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

  void onClickRetry() => _setupRegistration();

  void onClickContinueInitiallyNoFunds() => _setupRegistration();
}
