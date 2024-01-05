import 'package:givt_app/core/logging/logging.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ILocalAuthInfo {
  Future<bool> get canCheckBiometrics;
  Future<bool> authenticate();
  Future<bool> checkFaceId();
  Future<bool> checkFingerprint();
  Future<bool> setCanCheckBiometrics({required bool value});
}

class LocalAuthInfo with ILocalAuthInfo {
  factory LocalAuthInfo() => _singleton;

  LocalAuthInfo._internal() : _localAuth = LocalAuthentication();

  static final LocalAuthInfo _singleton = LocalAuthInfo._internal();

  static LocalAuthInfo get instance => _singleton;

  final LocalAuthentication _localAuth;

  static const String _canCheckBiometrics = 'canCheckBiometrics';

  @override
  Future<bool> get canCheckBiometrics async {
    await LoggingInfo.instance.info(
      'Checking if biometrics can be checked',
      methodName: 'canCheckBiometrics',
    );
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(_canCheckBiometrics) ?? false;
    });
  }

  @override
  Future<bool> authenticate() async {
    await LoggingInfo.instance.info(
      'Authenticating with biometrics',
      methodName: 'authenticate',
    );
    return _localAuth
        .authenticate(
      localizedReason: 'Login',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    )
        .onError((error, _) async {
      await LoggingInfo.instance.error(
        'Error authenticating with biometrics: $error',
      );
      return false;
    });
  }

  @override
  Future<bool> checkFaceId() async {
    await LoggingInfo.instance.info(
      'Checking for face id availability',
      methodName: 'checkFaceId',
    );
    final biometrics = await _localAuth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.face) ||
        biometrics.contains(BiometricType.strong);
  }

  @override
  Future<bool> checkFingerprint() async {
    await LoggingInfo.instance.info(
      'Checking for fingerprint availability',
      methodName: 'checkFingerprint',
    );
    final biometrics = await _localAuth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong);
  }

  @override
  Future<bool> setCanCheckBiometrics({required bool value}) async {
    await LoggingInfo.instance.info(
      'Fingerprint set to: $value',
      methodName: 'setCanCheckBiometrics',
    );
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_canCheckBiometrics, value);
  }
}
