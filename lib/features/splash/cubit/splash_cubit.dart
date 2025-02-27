import 'dart:async';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/features/splash/cubit/splash_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SplashCubit extends CommonCubit<void, SplashCustom> {
  SplashCubit(
    this._authRepository,
    this._profilesRepository,
    this._networkInfo,
  ) : super(const BaseState.loading());

  final FamilyAuthRepository _authRepository;
  final ProfilesRepository _profilesRepository;
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _internetConnectionSubscription;

  Future<void> init() async {
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
      await _authRepository.initAuth();
      final user = _authRepository.getCurrentUser();

      if (user == null) {
        emitCustom(const SplashCustom.redirectToWelcome());
        return;
      }

      if (false == user.isUsUser) return;
      final profiles = await _profilesRepository.refreshProfiles();

      final fbsdk = FacebookAppEvents();
      await fbsdk.setAutoLogAppEventsEnabled(true);
      await fbsdk.logEvent(
        name: 'app_open_and_logged_in',
      );

      if (!user.personalInfoRegistered) {
        _authRepository.onRegistrationStarted();
        emitCustom(SplashCustom.redirectToSignup(user.email));
        return;
      }

      if (profiles.isEmpty) {
        _showExperiencingIssuesMessage();
        // we probably have a BE issue
        LoggingInfo.instance.error(
          'No profiles found for user ${user.guid}, do we have a failing BE call?',
          methodName: 'SplashCubit._checkForRedirect',
        );
        return;
      } else if (profiles.length <= 1) {
        _authRepository.onRegistrationStarted();
        emitCustom(const SplashCustom.redirectToAddMembers());
        return;
      }

      emitCustom(const SplashCustom.redirectToHome());
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

  @override
  Future<void> close() async {
    await _internetConnectionSubscription?.cancel();
    await super.close();
  }
}
