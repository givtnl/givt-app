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
    emit(AuthLoading());
    try {
      // check email
      final result = await _authRepositoy.checkEmail(email);
      if (result.contains('temp')) {
        emit(AuthTempAccountWarning(email));
        return;
      }
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
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> checkAuth() async {
    emit(AuthLoading());
    try {
      final userExt = await _authRepositoy.isAuthenticated();
      if (userExt == null) {
        emit(AuthUnkown());
        return;
      }

      emit(AuthSuccess(userExt));
    } catch (e) {
      emit(const AuthFailure());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authRepositoy.logout();
    emit(AuthInitial());
  }

  Future<void> register({
    required String email,
    required String locale,
  }) async {
    emit(AuthLoading());
    try {
      if (!await _authRepositoy.checkTld(email)) {
        emit(const AuthFailure());
        return;
      }
      // check email
      final result = await _authRepositoy.checkEmail(email);
      if (result.contains('temp')) {
        emit(AuthTempAccountWarning(email));
        return;
      }
      if (result.contains('true')) {
        emit(AuthLoginRedirect(email));
        return;
      }

      // register temp user
      final unRegisteredUserExt =
          await _authRepositoy.registerTempUser(email, locale);

      emit(AuthSuccess(unRegisteredUserExt));
    } catch (e) {
      log(e.toString());
      emit(const AuthFailure());
    }
  }
}
