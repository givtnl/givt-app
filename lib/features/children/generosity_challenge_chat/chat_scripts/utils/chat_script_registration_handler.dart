import 'dart:async';
import 'dart:developer';

import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScriptRegistrationHandler {
  const ChatScriptRegistrationHandler(
      this._authRepository, this._sharedPreferences, this._apiService);

  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final APIService _apiService;

  Future<bool> handleRegistration() async {
    try {
      _updateAws();
      return _registerUser();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return false;
    }
  }

  Future<bool> _registerUser() async {
    final firstname = _sharedPreferences.getString(
      ChatScriptSaveKey.firstName.value,
    );
    final lastname = _sharedPreferences.getString(
      ChatScriptSaveKey.lastName.value,
    );
    final email = _sharedPreferences.getString(
      ChatScriptSaveKey.email.value,
    );
    final password = _sharedPreferences.getString(
      ChatScriptSaveKey.password.value,
    );
    return _authRepository.registerGenerosityChallengeUser(
      firstname: firstname!,
      lastname: lastname!,
      email: email!,
      password: password!,
    );
  }

  void _updateAws() {
    const baseUrl = String.fromEnvironment('API_URL_US');
    const baseUrlAWS = String.fromEnvironment('API_URL_AWS_US');

    log('Using API URL: $baseUrl');
    _apiService.updateApiUrl(baseUrl, baseUrlAWS);

    unawaited(
        _sharedPreferences.setString(Util.countryIso, Country.us.countryCode));
  }
}
