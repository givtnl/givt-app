import 'dart:io';

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
      : super(const AuthState());

  final AuthRepositoy _authRepositoy;
  final CountryIsoInfo _countryIsoInfo;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await LoggingInfo.instance.info('User is trying to login with $email');

      /// check if user is trying to login with a different account.
      /// if so delete the current user and login with the new one
      await _authRepositoy.checkUserExt(email: email);

      final session = await _authRepositoy.login(
        email,
        password,
      );

      final userExt = await _authRepositoy.fetchUserExtension(session.userGUID);

      await LoggingInfo.instance.info('User logged in with $userExt');

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: userExt,
          session: session,
        ),
      );
    } catch (e, stackTrace) {
      if (e.toString().contains('invalid_grant')) {
        await LoggingInfo.instance.warning(
          e.toString(),
          methodName: stackTrace.toString(),
        );
        if (e.toString().contains('TwoAttemptsLeft')) {
          emit(
            state.copyWith(status: AuthStatus.twoAttemptsLeft),
          );
          return;
        }
        if (e.toString().contains('OneAttemptLeft')) {
          emit(
            state.copyWith(status: AuthStatus.oneAttemptLeft),
          );
          return;
        }
        if (e.toString().contains('LockedOut')) {
          emit(
            state.copyWith(status: AuthStatus.lockedOut),
          );
          return;
        }
      } else if (e is SocketException) {
        emit(
          state.copyWith(
            status: AuthStatus.noInternet,
          ),
        );
        return;
      } else {
        await LoggingInfo.instance.error(
          e.toString(),
          methodName: stackTrace.toString(),
        );
      }

      emit(
        state.copyWith(
          status: AuthStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> checkAuth() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final (userExt, session, amountPresets) =
          await _authRepositoy.isAuthenticated() ?? (null, null, null);

      if (userExt == null || session == null) {
        emit(state.copyWith(status: AuthStatus.unknown));
        return;
      }

      await LoggingInfo.instance.info('CheckedAuth for $userExt');
      if (!session.isLoggedIn) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: userExt,
          session: session,
          presets: amountPresets,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await LoggingInfo.instance.info('User is logging out');

    ///TODO: I discussed this with @MaikelStuivenberg and will leave it as is for now. Until we will redesign the auth flow
    await _authRepositoy.logout();

    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        email: state.user.email,
      ),
    );
  }

  Future<void> register({
    required String email,
    required String locale,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      /// check if user is trying to login with a different account.
      /// if so delete the current user and login with the new one
      await _authRepositoy.checkUserExt(email: email);

      if (!await _authRepositoy.checkTld(email)) {
        emit(state.copyWith(status: AuthStatus.failure));
        return;
      }
      // check email
      final result = await _authRepositoy.checkEmail(email);
      if (result.contains('temp')) {
        await login(email: email, password: TempUser.defaultPassword);
        return;
      }
      if (result.contains('true')) {
        emit(state.copyWith(status: AuthStatus.loginRedirect));
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

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: unRegisteredUserExt,
        ),
      );
    } catch (e, stackTrace) {
      if (e is SocketException) {
        emit(
          state.copyWith(
            status: AuthStatus.noInternet,
          ),
        );
        return;
      }
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> refreshUser() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final userExt = await _authRepositoy.fetchUserExtension(state.user.guid);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: userExt,
          session: state.session,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<bool> authenticate() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final session = await _authRepositoy.refreshToken();

      final (userExt, _, amountPresets) =
          await _authRepositoy.isAuthenticated() ?? (null, null, null);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          user: userExt,
          presets: amountPresets,
        ),
      );
      return true;
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure));
    }
    return false;
  }

  Future<void> refreshSession() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await LoggingInfo.instance.info('Refreshing session');
      final session = await _authRepositoy.refreshToken();
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> changePassword({required String email}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      // check email
      final result = await _authRepositoy.checkEmail(email);
      if (result.contains('temp')) {
        emit(
          state.copyWith(
            status: AuthStatus.tempAccountWarning,
            email: email,
          ),
        );
        return;
      }
      if (result.contains('false')) {
        emit(
          state.copyWith(
            status: AuthStatus.changePasswordWrongEmail,
            email: email,
          ),
        );
        return;
      }
      await _authRepositoy.resetPassword(email);
      emit(state.copyWith(status: AuthStatus.changePasswordSuccess));
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.changePasswordFailure));
    }
  }

  Future<void> updatePresets({required UserPresets presets}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await LoggingInfo.instance.info('Updating user presets');
      await _authRepositoy.updateLocalUserPresets(
        newUserPresets: presets.copyWith(
          guid: state.user.guid,
        ),
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          presets: presets,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          message: e.toString(),
          status: AuthStatus.failure,
        ),
      );
    }
  }
}
