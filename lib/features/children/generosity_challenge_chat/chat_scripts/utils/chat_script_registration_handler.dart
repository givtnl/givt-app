import 'dart:async';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/utils/util.dart';

class ChatScriptRegistrationHandler {
  const ChatScriptRegistrationHandler(
    this._authRepository,
    this._generosityChallengeRepository,
  );

  final AuthRepository _authRepository;
  final GenerosityChallengeRepository _generosityChallengeRepository;

  Future<bool> handleRegistration() async {
    try {
      return await _registerUser();
    } catch (e, s) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: s.toString(),
      );
      return false;
    }
  }

  Future<bool> _registerUser() async {
    final userData = _generosityChallengeRepository.loadUserData();

    // Retrieve email, prioritize getting it directly from sharedPreferences, fallback to userData
    final email = GenerosityChallengeHelper.getChallengeEmail(userData);

    // Log and return false if email is empty
    if (email.isEmpty) {
      LoggingInfo.instance.error(
        'Failed to get sign up email.',
        methodName: '_registerUser',
      );
      return false;
    }

    // Extract other user data
    final firstname = userData[ChatScriptSaveKey.firstName.value] as String;
    final lastname = userData[ChatScriptSaveKey.lastName.value] as String;
    final password = userData[ChatScriptSaveKey.password.value] as String;
    final phoneNr = (userData[ChatScriptSaveKey.phone.value] ??
        Util.defaultUSPhoneNumber) as String;

    // Register the user
    final result = await _authRepository.registerGenerosityChallengeUser(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: password,
      phoneNumber: phoneNr,
    );

    // Handle registration result
    await _generosityChallengeRepository.setAlreadyRegistered(
      wasRegisteredBeforeChallenge: result.wasRegisteredBeforeChallenge,
    );

    return result.success;
  }
}
