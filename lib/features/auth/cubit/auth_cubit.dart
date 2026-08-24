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
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
part 'auth_state.dart';

/// Owns the EU / main-app OAuth session.
///
/// Expected behaviour (online unless noted):
/// * **App open:** silent refresh. Success keeps the user on home.
/// * **Refresh token rejected** (`invalid_grant`): [logout]. Do not keep a
///   local session, do not set [AuthState.needsReauthentication], do not
///   prompt Face ID, and do not show a dismissible login sheet.
/// * **Refresh fails for another reason** (e.g. server error): stay
///   authenticated and set [AuthState.needsReauthentication] so Home / give
///   can prompt biometrics or login.
/// * **Offline:** keep the local session; no popup.
/// * **Logout:** persist `isLoggedIn: false` before the session stream
///   notifies [checkAuth], and never emit [AuthStatus.loading] (that
///   redirects through splash and can bounce back to home).
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authRepositoy, {
    NetworkInfo? networkInfo,
  }) : _networkInfo = networkInfo,
       super(const AuthState()) {
    _sessionSubscription = _authRepositoy.hasSessionStream().listen((
      hasSession,
    ) {
      checkAuth(hasSession: hasSession);
    });
  }

  final AuthRepository _authRepositoy;
  final NetworkInfo? _networkInfo;
  late StreamSubscription<bool> _sessionSubscription;
  Future<RefreshSessionResult>? _inFlightRefresh;
  bool _isLoggingOut = false;

  bool get _isOnline => _networkInfo?.isConnected ?? true;

  /// True when OAuth `/oauth2/token` rejected the refresh token.
  /// That is a permanent session failure: the user must log in again.
  bool _isInvalidGrant(Object error) {
    if (error is GivtServerFailure) {
      return error.isInvalidGrant;
    }
    return error.toString().contains('invalid_grant');
  }

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
            eventName: AnalyticsEventName.continueByEmailSignUpTempUserClicked,
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

      final showBiometricCheck =
          biometricSetting == BiometricSetting.unknown &&
          userExt.tempUser == false;

      emit(
        state.copyWith(
          status: showBiometricCheck
              ? AuthStatus.biometricCheck
              : AuthStatus.authenticated,
          user: userExt,
          session: session,
          navigate: navigate,
          needsReauthentication: false,
        ),
      );
      unawaited(_authRepositoy.markLocalAuthSucceeded());
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
        if (e.toString().contains('AccountDisabled')) {
          emit(
            state.copyWith(status: AuthStatus.accountDisabled),
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

  void clearNeedsReauthentication() {
    if (!state.needsReauthentication) {
      return;
    }
    emit(
      state.copyWith(
        status: state.status,
        needsReauthentication: false,
      ),
    );
  }

  /// Loads the stored session and, when [isAppStartupCheck] and online,
  /// silently refreshes.
  ///
  /// Pass [hasSession] `false` from the session stream after logout. That
  /// path emits [AuthStatus.unauthenticated] without [AuthStatus.loading]
  /// so the router does not bounce splash → home while still logged in.
  Future<void> checkAuth({
    bool isAppStartupCheck = false,
    bool? hasSession,
  }) async {
    if (_isLoggingOut) {
      return;
    }

    // Logout notifies the session stream with false. Do not re-authenticate
    // from a still-cached session, and do not emit loading (that redirects
    // the router to the splash/loading route, then back to home).
    if (hasSession == false) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          email: state.user.email,
          needsReauthentication: false,
        ),
      );
      _authRepositoy.setHasSessionInitialValue(false);
      return;
    }

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

      var needsReauthentication = false;
      if (isAppStartupCheck && _isOnline) {
        try {
          LoggingInfo.instance.info('Refreshing session on app startup');
          session = await _authRepositoy.refreshToken();
        } on SocketException {
          LoggingInfo.instance.info(
            'No internet while refreshing session on startup; continuing offline',
          );
        } on Object catch (e, stackTrace) {
          if (_isInvalidGrant(e)) {
            LoggingInfo.instance.warning(
              'Refresh token invalid on app startup, logging out: $e',
              methodName: stackTrace.toString(),
            );
            await logout();
            return;
          }
          LoggingInfo.instance.warning(
            'Session refresh failed on app startup: $e',
            methodName: stackTrace.toString(),
          );
          needsReauthentication = true;
        }
      }

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
            needsReauthentication: needsReauthentication,
          ),
        );
      } else if (needsReauthentication) {
        emit(
          state.copyWith(
            status: currentStatus == AuthStatus.loading
                ? AuthStatus.authenticated
                : currentStatus,
            user: userExt,
            session: session,
            presets: amountPresets,
            needsReauthentication: true,
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

  /// Clears the local session and emits [AuthStatus.unauthenticated].
  ///
  /// Must not emit [AuthStatus.loading]. The repository persists
  /// `isLoggedIn: false` before notifying the session stream; [checkAuth]
  /// then treats `hasSession: false` as logged out instead of re-reading
  /// a still-logged-in cached session.
  Future<void> logout({bool fullReset = false}) async {
    if (_isLoggingOut) {
      return;
    }
    _isLoggingOut = true;
    LoggingInfo.instance.info('User is logging out');

    try {
      await _authRepositoy.logout();

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          email: fullReset ? null : state.user.email,
          user: fullReset ? const UserExt.empty() : state.user,
          session: const Session.empty(),
          needsReauthentication: false,
        ),
      );
      await _clearAnalyticsUserProperties();
    } finally {
      _isLoggingOut = false;
    }
  }

  Future<void> _clearAnalyticsUserProperties() async {
    try {
      await AnalyticsHelper.clearUserProperties();
    } on Object catch (e) {
      LoggingInfo.instance.warning(
        'Failed to clear analytics user properties: $e',
      );
    }
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
        timeZoneId: (await FlutterTimezone.getLocalTimezone()).identifier,
        amountLimit: country.isUS ? 4999 : 499,
      );

      var unRegisteredUserExt = await _authRepositoy.registerUser(
        tempUser: tempUser,
        isNewUser: true,
      );

      await AnalyticsHelper.setUserProperties(userId: unRegisteredUserExt.guid);

      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.continueByEmailSignUpNewUserCliked,
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

  void markLocalAuthSucceeded() {
    unawaited(_authRepositoy.markLocalAuthSucceeded());
  }

  /// Face ID / local-auth succeeded within [AuthGate.localAuthGracePeriod]
  /// (15 minutes). Used only by [CheckAuthPolicy.stepUp] on protected menu
  /// items — giving and app-open always use [CheckAuthPolicy.ensureSession].
  bool get isWithinLocalAuthGrace {
    final lastLocalAuthAt = _authRepositoy.lastLocalAuthAt();
    if (lastLocalAuthAt == null) {
      return false;
    }
    return DateTime.now().toUtc().difference(lastLocalAuthAt) <
        AuthGate.localAuthGracePeriod;
  }

  /// Refreshes the OAuth session.
  ///
  /// Returns [RefreshSessionResult.success] when a new session is stored,
  /// [RefreshSessionResult.offline] when the request fails due to no network,
  /// [RefreshSessionResult.invalidRefreshToken] when the refresh token is
  /// rejected (the user is logged out), and [RefreshSessionResult.failure]
  /// for other errors.
  ///
  /// Skips the network call when the access token is still valid unless
  /// [force] is true or [AuthState.needsReauthentication] is set. Concurrent
  /// callers share a single in-flight refresh.
  Future<RefreshSessionResult> refreshSession({
    bool emitAuthentication = true,
    bool force = false,
  }) async {
    if (!force &&
        !state.needsReauthentication &&
        state.session.isLoggedIn &&
        state.session.accessToken.isNotEmpty &&
        !state.session.isExpired) {
      return RefreshSessionResult.success;
    }

    final inFlight = _inFlightRefresh;
    if (inFlight != null) {
      return inFlight;
    }

    final refresh = _refreshSession(emitAuthentication: emitAuthentication);
    _inFlightRefresh = refresh;
    try {
      return await refresh;
    } finally {
      _inFlightRefresh = null;
    }
  }

  Future<RefreshSessionResult> _refreshSession({
    required bool emitAuthentication,
  }) async {
    if (emitAuthentication) emit(state.copyWith(status: AuthStatus.loading));
    try {
      LoggingInfo.instance.info('Refreshing session');
      final session = await _authRepositoy.refreshToken();
      emit(
        state.copyWith(
          status: emitAuthentication ? AuthStatus.authenticated : state.status,
          session: session,
          needsReauthentication: false,
        ),
      );
      return RefreshSessionResult.success;
    } on SocketException {
      log('No internet connection');
      if (emitAuthentication) {
        emit(state.copyWith(status: AuthStatus.noInternet));
      }
      return RefreshSessionResult.offline;
    } catch (e, stackTrace) {
      if (_isInvalidGrant(e)) {
        LoggingInfo.instance.warning(
          'Refresh token invalid, logging out: $e',
          methodName: stackTrace.toString(),
        );
        await logout();
        return RefreshSessionResult.invalidRefreshToken;
      }
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      if (emitAuthentication) {
        emit(state.copyWith(status: AuthStatus.failure));
      }
      return RefreshSessionResult.failure;
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

      LoggingInfo.instance.info(
        'New FCM token: $notificationId; '
        'Notification permission status: $notificationPermissionStatus',
      );

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
