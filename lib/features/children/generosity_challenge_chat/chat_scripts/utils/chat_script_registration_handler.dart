import 'dart:async';
import 'dart:developer';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/domain/models/generosity_registration_result.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScriptRegistrationHandler {
  const ChatScriptRegistrationHandler(
    this._authRepository,
    this._sharedPreferences,
    this._generosityChallengeRepository,
  );

  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;
  final GenerosityChallengeRepository _generosityChallengeRepository;

  Future<bool> handleRegistration() async {
    try {
      return await _registerUser();
    } catch (e, s) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
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
    final result = await _authRepository.registerGenerosityChallengeUser(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
    );
    await _generosityChallengeRepository.setAlreadyRegistered(
      isAlreadyRegistered: result.isAlreadyRegistered,
    );
    return result.success;
  }
}
