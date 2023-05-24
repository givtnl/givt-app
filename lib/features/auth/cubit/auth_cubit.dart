import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepositoy) : super(AuthInitial());

  final AuthRepositoy _authRepositoy;

  Future<void> login({required String email, required String password}) async {
    try {
      final userGUID = await _authRepositoy.login(
        email,
        password,
      );

      emit(
        AuthSuccess(
          await _authRepositoy.fetchUserExtension(userGUID),
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(AuthFailure());
    }
  }

  Future<void> checkAuth() async {
    try {
      final userExt = await _authRepositoy.isAuthenticated();
      if (userExt == null) {
        emit(AuthFailure());
        return;
      }

      emit(AuthSuccess(userExt));
    } catch (e) {
      emit(AuthFailure());
    }
  }

  Future<void> logout() async {
    await _authRepositoy.logout();
    emit(AuthInitial());
  }

  Future<void> register({
    required String email,
    required String locale,
  }) async {
    try {
      if (!await _authRepositoy.checkTld(email)) {
        emit(AuthFailure());
        return;
      }
      // check email
      if (await _authRepositoy.checkEmail(email)) {
        emit(AuthFailure());
        return;
      }
      // register temp user
      final unRegisteredUserExt =
          await _authRepositoy.registerTempUser(email, locale);

      emit(AuthSuccess(unRegisteredUserExt));
    } catch (e) {
      log(e.toString());
      emit(AuthFailure());
    }
  }
}
