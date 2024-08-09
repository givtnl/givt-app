import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/models.dart';

class GenerosityStripeRegistrationCubit
    extends Cubit<BaseState<dynamic, dynamic>> {
  GenerosityStripeRegistrationCubit(
    this._authRepository,
  ) : super(const BaseState.loading());

  final AuthRepository _authRepository;
  Future<StripeResponse> setupStripeRegistration() async {
    try {
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
