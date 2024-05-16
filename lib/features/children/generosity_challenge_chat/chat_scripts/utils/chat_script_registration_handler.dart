import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScriptRegistrationHandler {
  const ChatScriptRegistrationHandler(
      this._authRepository,
      this._sharedPreferences,
      this._generosityChallengeRepository,
      this._apiService);

  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final GenerosityChallengeRepository _generosityChallengeRepository;
  final APIService _apiService;

  Future<bool> handleRegistration() async {
    try {
      _updateAws();
      return await _registerUser();
    } catch (e, s) {
      if(e is PlatformException && e.code == "CONNECTION_NOT_SECURE") {
        try {
          await _authRepository.updateFingerprintCertificate();
        } catch (e, s) {
          log(e.toString());
          log(s.toString());
        }
      }
      log(e.toString());
      log(s.toString());
      return false;
    }
  }

  Future<bool> _registerUser() async {
    final userData = _generosityChallengeRepository.loadUserData();
    log(_sharedPreferences.getKeys().toString());
    final firstname = userData[ChatScriptSaveKey.firstName.value] as String;
    final lastname = userData[ChatScriptSaveKey.lastName.value] as String;
    final email = userData[ChatScriptSaveKey.email.value] as String;
    final password = userData[ChatScriptSaveKey.password.value] as String;
    return _authRepository.registerGenerosityChallengeUser(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
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
