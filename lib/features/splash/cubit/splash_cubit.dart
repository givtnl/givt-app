import 'dart:async';
import 'dart:convert';

import 'package:backoff/backoff.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/auth/models/session.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends CommonCubit<void, SplashCustom> {
  SplashCubit(
    this._authRepository,
    this._familyAuthRepository,
    this._profilesRepository,
    this._networkInfo,
  ) : super(const BaseState.loading());

  final AuthRepository _authRepository;
  final FamilyAuthRepository _familyAuthRepository;
  final ProfilesRepository _profilesRepository;
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _internetConnectionSubscription;
  late ExponentialBackOff _backOff;

  Future<void> init() async {
    _backOff = ExponentialBackOff(initialIntervalMillis: 3000);

    _internetConnectionSubscription = _networkInfo
        .hasInternetConnectionStream()
        .listen((hasInternetConnection) async {
      if (hasInternetConnection) {
        await _checkForRedirect();
      } else {
        _showNoInternetMessage();
      }
    });
    if (_networkInfo.isConnected) {
      await _checkForRedirect();
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
      //for the session it doesn't matter if we use the family one or the EU one
      //for now because they are both stored in the same place using the same object
      final session = await _authRepository.getStoredSession();

      final user = await _getUser();
      final isUSUser = await _isUSUser();

      // we don't have a session/ user, go to welcome
      if (session == const Session.empty() || user == null) {
        emitCustom(const SplashCustom.redirectToWelcome());
        return;
      }

      // we are logged in as a EU user, go to EU home
      if (session.isLoggedIn && (user.isUsUser == false || !isUSUser)) {
        emitCustom(const SplashCustom.redirectToEUHome());
        return;
      }

      // we are not logged in but we did have a session, go to email signup
      if (session.isLoggedIn == false) {
        emitCustom(SplashCustom.redirectToEmailSignup(session.email));
        return;
      }

      // we are logged in and have a session as a US user
      await _familyAuthRepository.initAuth();
      final profiles = await _profilesRepository.refreshProfiles();

      final fbsdk = FacebookAppEvents();
      await fbsdk.setAutoLogAppEventsEnabled(true);
      await fbsdk.logEvent(
        name: 'app_open_and_logged_in',
      );

      // user started registration but didn't finish yet
      if (!user.personalInfoRegistered) {
        _familyAuthRepository.onRegistrationStarted();
        emitCustom(SplashCustom.redirectToUSRegistration(user.email));
        return;
      }

      if (profiles.isEmpty) {
        // we probably have a BE issue or internet connection issue
        await _handleNoProfilesIssue(user);
        return;
      } else if (profiles.length <= 1) {
        // user started registration but didn't create a family yet
        _familyAuthRepository.onRegistrationStarted();
        emitCustom(const SplashCustom.redirectToAddMembers());
        return;
      }

      // we have a logged in US user that fully went through registration
      emitCustom(const SplashCustom.redirectToUSHome());
    } catch (e, s) {
      if (_networkInfo.isConnected) {
        await _handleExceptionNotDueToInternetConnection(e, s);
      } else {
        _showNoInternetMessage();
      }
    }
  }

  Future<void> _handleExceptionNotDueToInternetConnection(
      Object e, StackTrace s) async {
    LoggingInfo.instance.error(
      '$e\n\n$s',
      methodName: 'SplashCubit._checkForRedirect',
    );
    if (_isBENotAvailableDueToDDOS(e)) {
      // let's retry after a bit of time and see if the server is available
      await _retryAfterABitOfTime();
    } else {
      //we can't recover from this
      emitCustom(const SplashCustom.redirectToWelcome());
    }
  }

  bool _isBENotAvailableDueToDDOS(Object e) =>
      e.toString().toLowerCase().contains('format');

  Future<void> _handleNoProfilesIssue(UserExt user) async {
    // we probably have a BE issue
    LoggingInfo.instance.error(
      'No profiles found for user ${user.guid}, do we have a failing BE call?',
      methodName: 'SplashCubit._handleNoProfilesIssue',
    );
    await _retryAfterABitOfTime();
  }

  Future<void> _retryAfterABitOfTime() async {
    _showExperiencingIssuesMessage();
    final nextBackOff = _backOff.nextBackOffMillis();
    if (nextBackOff != BackOff.STOP) {
      await Future.delayed(Duration(milliseconds: nextBackOff));
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

  Future<bool> _isUSUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(UserExt.tag)) {
      final userExtString = prefs.getString(UserExt.tag);
      if (userExtString != null) {
        final user =
            UserExt.fromJson(jsonDecode(userExtString) as Map<String, dynamic>);
        return user.country == Country.us.countryCode;
      }
    }

    return false;
  }

  @override
  Future<void> close() async {
    await _internetConnectionSubscription?.cancel();
    await super.close();
  }
}
