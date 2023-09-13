import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/country_iso_info.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/models.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepositoy, this._countryIsoInfo)
      : super(const AuthUnknown());

  final AuthRepositoy _authRepositoy;
  final CountryIsoInfo _countryIsoInfo;

  Future<void> login({required String email, required String password}) async {
    final prevState = state;
    emit(AuthLoading());
    try {
      /// check if user is trying to login with a different account.
      /// if so delete the current user and login with the new one
      await _authRepositoy.checkUserExt(email: email);

      final session = await _authRepositoy.login(
        email,
        password,
      );

      emit(
        AuthSuccess(
          user: await _authRepositoy.fetchUserExtension(session.userGUID),
          session: session,
        ),
      );
    } catch (e, stackTrace) {
      if (e.toString().contains('invalid_grant')) {
        await LoggingInfo.instance.warning(
          e.toString(),
          methodName: stackTrace.toString(),
        );
      } else {
        await LoggingInfo.instance.error(
          e.toString(),
          methodName: stackTrace.toString(),
        );
      }

      emit(
        AuthFailure(
          message: e.toString(),
          user: prevState.user,
          session: prevState.session,
        ),
      );
    }
  }

  Future<void> checkAuth() async {
    emit(AuthLoading());
    try {
      final (userExt, session) =
          await _authRepositoy.isAuthenticated() ?? (null, null);
      if (userExt == null || session == null) {
        emit(const AuthUnknown());
        return;
      }
      if (!session.isLoggedIn) {
        emit(AuthLogout(user: userExt, session: session));
        return;
      }

      emit(AuthSuccess(user: userExt, session: session));
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(const AuthFailure());
    }
  }

  Future<void> logout() async {
    final prevState = state;
    emit(AuthLoading());

    ///TODO: I discussed this with @MaikelStuivenberg and will leave it as is for now. Until we will redesign the auth flow
    await _authRepositoy.logout();

    emit(AuthLogout(user: prevState.user, session: prevState.session));
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
        await login(email: email, password: TempUser.defaultPassword);
        return;
      }
      if (result.contains('true')) {
        emit(AuthLoginRedirect(email: email));
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

      emit(AuthSuccess(user: unRegisteredUserExt));
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(const AuthFailure());
    }
  }

  Future<void> refreshUser() async {
    final guid = state.user.guid;
    emit(AuthLoading());
    try {
      final userExt = await _authRepositoy.fetchUserExtension(guid);
      emit(
        AuthRefreshed(
          user: userExt,
          session: state.session,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(const AuthFailure());
    }
  }

  Future<bool> authenticate() async {
    final prevState = state;
    emit(AuthLoading());
    try {
      final session = await _authRepositoy.refreshToken();
      emit(
        AuthSuccess(
          user: prevState.user,
          session: session,
        ),
      );
      return true;
    } catch (e) {
      emit(const AuthFailure());
    }
    return false;
  }

  Future<void> refreshSession() async {
    final user = state.user;
    emit(AuthLoading());
    try {
      final session = await _authRepositoy.refreshToken();
      emit(
        AuthRefreshed(
          user: user,
          session: session,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(const AuthFailure());
    }
  }

  Future<void> changePassword({required String email}) async {
    final prevState = state;
    emit(AuthLoading());
    try {
      // check email
      final result = await _authRepositoy.checkEmail(email);
      if (result.contains('temp')) {
        emit(AuthTempAccountWarning(email: email));
        return;
      }
      if (result.contains('false')) {
        emit(AuthChangePasswordWrongEmail(email: email));
        return;
      }
      await _authRepositoy.resetPassword(email);
      emit(AuthChangePasswordSuccess(user: prevState.user));
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(const AuthChangePasswordFailure());
    }
  }

  Future<void> updatePresets({required UserPresets presets}) async {
    final prevState = state;
    emit(AuthLoading());
    try {
      final user = prevState.user.copyWith(
        presets: presets,
      );
      await _authRepositoy.updateLocalUserExt(
        newUserExt: user,
      );
      emit(
        AuthSuccess(
          user: user,
          session: prevState.session,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        AuthFailure(
          message: e.toString(),
          user: prevState.user,
          session: prevState.session,
        ),
      );
    }
  }
}
