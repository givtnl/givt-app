import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:givt_app/core/network/country_iso_info.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/models.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepositoy, this._countryIsoInfo) : super(AuthUnkown());

  final AuthRepositoy _authRepositoy;
  final CountryIsoInfo _countryIsoInfo;

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
      log(e.toString());
      emit(const AuthFailure());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authRepositoy.logout();
    emit(AuthLogout());
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

      final countryIso = await _countryIsoInfo.checkCountryIso;

      final tempUser = TempUser.prefilled(
        email: email,
        country: countryIso,
        appLanguage: locale,
        timeZoneId: await FlutterNativeTimezone.getLocalTimezone(),
        amountLimit: _countryIsoInfo.isUS ? 4999 : 499,
      );

      // register temp user
      final unRegisteredUserExt = await _authRepositoy.registerUser(
        tempUser: tempUser,
        isTempUser: true,
      );

      emit(AuthSuccess(unRegisteredUserExt));
    } catch (e) {
      log(e.toString());
      emit(const AuthFailure());
    }
  }

  Future<void> refreshUser() async {
    final guid = (state as AuthSuccess).user.guid;
    emit(AuthLoading());
    try {
      final userExt = await _authRepositoy.fetchUserExtension(guid);
      emit(AuthSuccess(userExt));
    } catch (e) {
      emit(const AuthFailure());
    }
  }

  Future<void> changePassword({required String email}) async {
    emit(AuthLoading());
    try {
      // check email
      final result = await _authRepositoy.checkEmail(email);
      if (result.contains('temp')) {
        emit(AuthTempAccountWarning(email));
        return;
      }
      if (result.contains('false')) {
        emit(AuthChangePasswordWrongEmail(email));
        return;
      }
      await _authRepositoy.resetPassword(email);
      emit(const AuthChangePasswordSuccess());
    } catch (e) {
      log(e.toString());
      emit(const AuthChangePasswordFailure());
    }
  }
}
