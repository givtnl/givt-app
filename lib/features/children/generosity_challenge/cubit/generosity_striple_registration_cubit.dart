import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/models.dart';

class GenerosityStripeRegistrationCubit
    extends Cubit<BaseState<dynamic, dynamic>> {
  GenerosityStripeRegistrationCubit(
      this._authRepository, this._generosityChallengeRepository)
      : super(const BaseState.loading());

  final AuthRepository _authRepository;
  final GenerosityChallengeRepository _generosityChallengeRepository;
  Future<StripeResponse> setupStripeRegistration() async {
    try {
      final userData = _generosityChallengeRepository.loadUserData();
      final password = userData[ChatScriptSaveKey.password.value] as String;
      final email = GenerosityChallengeHelper.getChallengeEmail(userData);
      await _authRepository.login(email, password);
      await _authRepository.refreshToken(refreshUserExt: true);
    } catch (e, s) {
      LoggingInfo.instance.info(
        e.toString(),
        methodName: s.toString(),
      );
    }
    return _authRepository.fetchStripeSetupIntent();
  }
}
