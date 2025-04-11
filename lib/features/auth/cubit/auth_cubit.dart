import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepositoy) : super(const AuthState()) {
    _sessionSubscription =
        _authRepositoy.hasSessionStream().listen((hasSession) {
      checkAuth(hasSession: hasSession);
    });
  }

  final AuthRepository _authRepositoy;
  late StreamSubscription<bool> _sessionSubscription;

  @override
  Future<void> close() async {
    await _sessionSubscription.cancel();
    await super.close();
  }

  Future<void> login({
    required String email,
    required String password,
    Future<void> Function(BuildContext context)? navigate,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      LoggingInfo.instance.info('User is trying to login with $email');

      /// check if user is trying to login with a different account.
      /// if so delete the current user and login with the new one
      await _authRepositoy.checkUserExt(email: email);

      final session = await _authRepositoy.login(
        email,
        password,
      );

      var userExt = await _authRepositoy.fetchUserExtension(session.userGUID);
      if (password == TempUser.defaultPassword) {
        await AnalyticsHelper.setUserProperties(userId: userExt.guid);
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: AmplitudeEvents.continueByEmailSignUpTempUserClicked,
            eventProperties: {
              'profile_country': userExt.countryCode,
            },
          ),
        );
      }

      LoggingInfo.instance.info('User logged in with $userExt');

      final newNotificationId = await _updateNotificationId(
        userExt: userExt,
      );

      userExt = userExt.copyWith(
        notificationId: newNotificationId,
      );

      final biometricSetting = await BiometricsHelper.getBiometricSetting();

      final showBiometricCheck = biometricSetting == BiometricSetting.unknown &&
          userExt.tempUser == false;

      emit(
        state.copyWith(
          status: showBiometricCheck
              ? AuthStatus.biometricCheck
              : AuthStatus.authenticated,
          user: userExt,
          session: session,
          navigate: navigate,
        ),
      );
      _authRepositoy.updateSessionStream(true);
    } catch (e, stackTrace) {
      if (e.toString().contains('invalid_grant')) {
        LoggingInfo.instance.warning(
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
        LoggingInfo.instance.error(
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

  void completeBiometricsCheck() =>
      emit(state.copyWith(status: AuthStatus.authenticated));

  void clearNavigation() => emit(
        state.copyWith(
          status: state.status,
          navigate: AuthState._emptyNavigate,
        ),
      );

  Future<void> checkAuth({
    bool isAppStartupCheck = false,
    bool? hasSession,
  }) async {
    final currentStatus = state.status;
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      var (userExt, session, amountPresets) =
          await _authRepositoy.isAuthenticated() ?? (null, null, null);

      if (userExt == null || session == null) {
        emit(state.copyWith(status: AuthStatus.unknown));
        _authRepositoy.setHasSessionInitialValue(false);
        return;
      }

      LoggingInfo.instance.info('CheckedAuth for $userExt');
      if (!session.isLoggedIn) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: userExt));
        _authRepositoy.setHasSessionInitialValue(false);
        return;
      }

      if (userExt.isUsUser) return;

      // Update notification id if needed
      final newNotificationId = await _updateNotificationId(
        userExt: userExt,
      );

      userExt = userExt.copyWith(
        notificationId: newNotificationId,
      );

      if (hasSession == null || hasSession != true) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: userExt,
            session: session,
            presets: amountPresets,
          ),
        );
      }

      if (state.status == AuthStatus.loading) {
        emit(
          state.copyWith(
            status: currentStatus,
          ),
        );
      }

      _authRepositoy.setHasSessionInitialValue(true);
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
      _authRepositoy.setHasSessionInitialValue(false);
    }
  }

  Future<void> logout({bool fullReset = false}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    LoggingInfo.instance.info('User is logging out');

    await _authRepositoy.logout();

    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        email: fullReset ? null : state.user.email,
        user: fullReset ? const UserExt.empty() : state.user,
      ),
    );
    AnalyticsHelper.clearUserProperties();
  }

  Future<void> register({
    required Country country,
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

      // Get information about emailadres
      final result = await _authRepositoy.checkEmail(email);

      // When this is a temp user, we skip the login page
      if (result.contains('temp')) {
        await login(email: email, password: TempUser.defaultPassword);
        return;
      }

      // When this is a registered user, we show the login page
      if (result.contains('true')) {
        emit(state.copyWith(status: AuthStatus.loginRedirect, email: email));
        return;
      }

      // Otherwise we create a temp user
      final tempUser = TempUser.prefilled(
        email: email,
        country: country.countryCode,
        appLanguage: locale,
        timeZoneId: await FlutterTimezone.getLocalTimezone(),
        amountLimit: country.isUS ? 4999 : 499,
      );

      var unRegisteredUserExt = await _authRepositoy.registerUser(
        tempUser: tempUser,
        isNewUser: true,
      );

      await AnalyticsHelper.setUserProperties(userId: unRegisteredUserExt.guid);

      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.continueByEmailSignUpNewUserCliked,
        eventProperties: {
          'id': unRegisteredUserExt.guid,
          'profile_country': country.countryCode,
        },
      );

      final newNotificationId = await _updateNotificationId(
        userExt: unRegisteredUserExt,
      );

      unRegisteredUserExt = unRegisteredUserExt.copyWith(
        notificationId: newNotificationId,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: unRegisteredUserExt,
        ),
      );
      _authRepositoy.updateSessionStream(true);
    } catch (e, stackTrace) {
      if (e is SocketException) {
        emit(
          state.copyWith(
            status: AuthStatus.noInternet,
          ),
        );
        return;
      }
      if (e is CertificatesException ||
          e.toString().contains('CONNECTION_NOT_SECURE')) {
        emit(
          state.copyWith(
            status: AuthStatus.certificateException,
          ),
        );
        LoggingInfo.instance.error(
          e.toString(),
          methodName: stackTrace.toString(),
        );
        return;
      }
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> refreshUser({bool emitAuthentication = true}) async {
    if (emitAuthentication) emit(state.copyWith(status: AuthStatus.loading));
    try {
      final userExt = await _authRepositoy.fetchUserExtension(state.user.guid);
      if (emitAuthentication) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: userExt,
            session: state.session,
          ),
        );
      }
      _authRepositoy.updateSessionStream(true);
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
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
    } on SocketException {
      final (userExt, session, amountPresets) =
          await _authRepositoy.isAuthenticated() ?? (null, null, null);
      if (userExt == null || session == null) {
        emit(state.copyWith(status: AuthStatus.unknown));
        return false;
      }
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          user: userExt,
          presets: amountPresets,
        ),
      );
      return true;
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
    }
    return false;
  }

  // returns whether the session was succesfully refreshed
  Future<bool> refreshSession({bool emitAuthentication = true}) async {
    if (emitAuthentication) emit(state.copyWith(status: AuthStatus.loading));
    try {
      LoggingInfo.instance.info('Refreshing session');
      final session = await _authRepositoy.refreshToken();
      if (emitAuthentication) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            session: session,
          ),
        );
      }
      return true;
    } on SocketException {
      log('No internet connection');
      emit(state.copyWith(status: AuthStatus.noInternet));
      return false;
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.failure));
      return false;
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
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: AuthStatus.changePasswordFailure));
    }
  }

  Future<void> updatePresets({required UserPresets presets}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      LoggingInfo.instance.info('Updating user presets');
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
      LoggingInfo.instance.error(
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

  Future<String> _updateNotificationId({
    required UserExt userExt,
  }) async {
    try {
      final guid = userExt.guid;

      LoggingInfo.instance.info('Update Notification Id');

      if (Platform.isIOS) {
        // On iOS be sure that APNS token is available before asking for a firebase token
        await FirebaseMessaging.instance.getAPNSToken();
      }

      final notificationId = await FirebaseMessaging.instance.getToken();
      final notificationPermissionStatus =
          await Permission.notification.status.isGranted;

      LoggingInfo.instance.info('New FCM token: $notificationId; '
          'Notification permission status: $notificationPermissionStatus');

      if (userExt.notificationId == notificationId &&
          userExt.pushNotificationsEnabled == notificationPermissionStatus) {
        LoggingInfo.instance.info(
          'FCM token: $notificationId is the same as the current one',
        );

        return userExt.notificationId;
      }
      if (notificationId == null) {
        LoggingInfo.instance.warning(
          'FCM token: is null',
        );
        return userExt.notificationId;
      }

      LoggingInfo.instance.info('Updating notification id');

      if (guid.isEmpty) {
        LoggingInfo.instance.warning(
          'Tried to update notification id with empty guid',
        );
        return userExt.notificationId;
      }

      await _authRepositoy.updateNotificationId(
        notificationId: notificationId,
        notificationPermissionStatus: notificationPermissionStatus,
        guid: guid,
      );
      return notificationId;
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      return userExt.notificationId;
    }
  }
}
