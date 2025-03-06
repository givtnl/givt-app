import 'dart:async';

import 'package:backoff/backoff.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
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
  bool _shouldRetryDueToAppDDos = false;
  late ExponentialBackOff _backOff;

  Future<void> init() async {
    _backOff = ExponentialBackOff();

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
      final euSession = await _getEUSession();
      if (euSession != null) {
        if (euSession.isLoggedIn) {
          emitCustom(const SplashCustom.redirectToEUHome());
          return;
        } else {
          // user logged out, upon seeing the signup screen they will see biometrics to easily login
          emitCustom(SplashCustom.redirectToSignup(euSession.email));
          return;
        }
      }

      // if we reached here we don't have an EU user with a session
      // possibly we do have a US user
      final usUser = await _getUSUser();

      if (usUser == null) {
        if (_networkInfo.isConnected && !_shouldRetryDueToAppDDos) {
          // we don't have a US user, we had internet and no checks failed
          // so we don't have an existing session at all
          emitCustom(const SplashCustom.redirectToWelcome());
          return;
        } else {
          // something went wrong trying to retrieve the US user
          // let's keep retrying with exponential backoff (so we don't DDOS the server)
          _shouldRetryDueToAppDDos = false;
          final nextBackOff = _backOff.nextBackOffMillis();
          if (nextBackOff == BackOff.STOP) {
            await Future.delayed(Duration(milliseconds: nextBackOff));
            await _checkForRedirect();
            return;
          } else {
            // we've tried for a long time, time to give up (and leave the server alone!)
            emitCustom(const SplashCustom.redirectToWelcome());
            return;
          }
        }
      }

      // ah the age old classic, this shouldn't happen but...
      if (usUser.isUsUser == false) {
        emitCustom(const SplashCustom.redirectToEUHome());
        return;
      }

      // if we are here we've had an existing US session before
      // we now check where we should redirect the user to
      final profiles = await _profilesRepository.refreshProfiles();

      final fbsdk = FacebookAppEvents();
      await fbsdk.setAutoLogAppEventsEnabled(true);
      await fbsdk.logEvent(
        name: 'app_open_and_logged_in',
      );

      if (!usUser.personalInfoRegistered) {
        _familyAuthRepository.onRegistrationStarted();
        emitCustom(SplashCustom.redirectToSignup(usUser.email));
        return;
      }

      if (profiles.isEmpty) {
        _showExperiencingIssuesMessage();
        // we probably have a BE issue
        LoggingInfo.instance.error(
          'No profiles found for user ${usUser.guid}, do we have a failing BE call?',
          methodName: 'SplashCubit._checkForRedirect',
        );
        return;
      } else if (profiles.length <= 1) {
        _familyAuthRepository.onRegistrationStarted();
        emitCustom(const SplashCustom.redirectToAddMembers());
        return;
      }

      emitCustom(const SplashCustom.redirectToUSHome());
    } catch (e, s) {
      if (_networkInfo.isConnected) {
        LoggingInfo.instance.error(
          '$e\n\n$s',
          methodName: 'SplashCubit._checkForRedirect',
        );
        emitCustom(const SplashCustom.redirectToWelcome());
      } else {
        _showNoInternetMessage();
      }
    }
  }

  Future<Session?> _getEUSession() async {
    try {
      return await _authRepository.getStoredSession();
    } catch (e, s) {
      LoggingInfo.instance.error(
        s.toString(),
        methodName: 'SplashCubit._getEUUser',
      );
      return null;
    }
  }

  Future<UserExt?> _getUSUser() async {
    try {
      await _familyAuthRepository.initAuth();
      final usUser = _familyAuthRepository.getCurrentUser();
      final session = _familyAuthRepository.getStoredSession();
      return session.isLoggedIn ? usUser : null;
    } catch (e, s) {
      _checkForServiceNotAvailableException(e);
      LoggingInfo.instance.error(
        s.toString(),
        methodName: 'SplashCubit._getUSUser',
      );
      return null;
    }
  }

  // We get a format exception because the BE returns a ServerNotAvailableException
  // rather than a GivtServerFailure when being DDOSd (by the app :p)
  void _checkForServiceNotAvailableException(Object e) {
    if (e.toString().toLowerCase().contains('formatexception')) {
      _shouldRetryDueToAppDDos = true;
    }
  }

  @override
  Future<void> close() async {
    await _internetConnectionSubscription?.cancel();
    await super.close();
  }
}
