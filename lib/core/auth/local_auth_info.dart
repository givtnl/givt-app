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

  @override
  Future<bool> get canCheckBiometrics {
    return SharedPreferences.getInstance().then((prefs) {
      return prefs.getBool(_canCheckBiometrics) ?? false;
    });
  }

  @override
  Future<bool> authenticate() async {
    return _localAuth.authenticate(
      localizedReason: 'Login',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }

  @override
  Future<bool> checkFaceId() async {
    final biometrics = await _localAuth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  @override
  Future<bool> checkFingerprint() async {
    final biometrics = await _localAuth.getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong);
  }

  @override
  Future<bool> setCanCheckBiometrics({required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_canCheckBiometrics, value);
  }

  static const String _canCheckBiometrics = 'canCheckBiometrics';
}
