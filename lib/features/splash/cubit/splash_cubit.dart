import 'dart:async';
import 'dart:convert';

import 'package:backoff/backoff.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends CommonCubit<void, SplashCustom> {
  SplashCubit(
    this._authRepository,
    this._networkInfo,
  ) : super(const BaseState.loading());

  final AuthRepository _authRepository;
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _internetConnectionSubscription;
  late ExponentialBackOff _backOff;

  Future<void> init() async {
    // prevent BE from being DDOSd by the app
    _backOff = ExponentialBackOff(initialIntervalMillis: 3000);

    _internetConnectionSubscription = _networkInfo
        .hasInternetConnectionStream()
        .listen((hasInternetConnection) async {
      if (isClosed) return;
      if (hasInternetConnection) {
        await _checkForRedirect();
        if (isClosed) return;
      } else {
        _showNoInternetMessage();
      }
    });
    if (_networkInfo.isConnected) {
      await _checkForRedirect();
      if (isClosed) return;
    } else {
      _showNoInternetMessage();
    }
  }

  void _showNoInternetMessage() {
    emitCustom(const SplashCustom.noInternet());
    emitLoading();
  }

  void _showExperiencingIssuesMessage() {
    emitCustom(const SplashCustom.experiencingIssues());
    emitLoading();
  }

  Future<void> _checkForRedirect() async {
    try {
      final session = await _authRepository.getStoredSession();
      if (isClosed) return;

      final user = await _getUser();
      if (isClosed) return;

      // we don't have a session/ user, go to welcome
      if (session == const Session.empty() || user == null) {
        emitCustom(const SplashCustom.redirectToWelcome());
        return;
      }

      // Logged in (EU or US): AuthCubit + shell handle navigation to home.
      if (session.isLoggedIn) {
        return;
      }

      // we are not logged in but we did have a session, go to email signup
      emitCustom(SplashCustom.redirectToEmailSignup(session.email));
    } catch (e, s) {
      LoggingInfo.instance.error(
        '$e\n\n$s',
        methodName: 'SplashCubit._checkForRedirect',
      );
      if (_networkInfo.isConnected) {
        await _handleExceptionNotDueToInternetConnection(e, s);
        if (isClosed) return;
      } else {
        _showNoInternetMessage();
      }
    }
  }

  Future<void> _handleExceptionNotDueToInternetConnection(
      Object e, StackTrace s) async {
    if (_isBENotAvailableDueToDDOS(e)) {
      // let's retry after a bit of time and see if the server is available
      await _retryAfterABitOfTime();
      if (isClosed) return;
    } else {
      //we can't recover from this
      if (isClosed) return;
      emitCustom(const SplashCustom.redirectToWelcome());
    }
  }

  bool _isBENotAvailableDueToDDOS(Object e) =>
      e.toString().toLowerCase().contains('format');

  Future<void> _retryAfterABitOfTime() async {
    _showExperiencingIssuesMessage();
    if (isClosed) return;

    final nextBackOff = _backOff.nextBackOffMillis();
    if (nextBackOff != BackOff.STOP) {
      await Future<void>.delayed(
        Duration(milliseconds: nextBackOff),
      );
      if (isClosed) return;
      await _checkForRedirect();
    }
  }

  Future<UserExt?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(UserExt.tag)) {
      final userExtString = prefs.getString(UserExt.tag);
      if (userExtString != null) {
        final user =
            UserExt.fromJson(jsonDecode(userExtString) as Map<String, dynamic>);
        return user;
      }
    }

    return null;
  }

  @override
  Future<void> close() async {
    await _internetConnectionSubscription?.cancel();
    await super.close();
  }
}
