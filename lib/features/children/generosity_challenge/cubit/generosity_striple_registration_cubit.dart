import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityStripeRegistrationCubit
    extends Cubit<BaseState<dynamic, dynamic>> {
  GenerosityStripeRegistrationCubit(
    this._authRepository,
    this._sharedPreferences,
    this._apiService,
  ) : super(const BaseState.loading());

  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final APIService _apiService;

  Future<StripeResponse> setupStripeRegistration() async {
    _updateUrlsAndCountry();
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
    try {
      await _authRepository.refreshToken(refreshUserExt: true);
    } catch (e, s) {
      unawaited(
        LoggingInfo.instance.info(
          e.toString(),
          methodName: s.toString(),
        ),
      );
    }
    return _authRepository.fetchStripeSetupIntent();
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
}
