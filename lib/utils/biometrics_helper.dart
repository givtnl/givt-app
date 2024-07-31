import 'dart:io';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BiometricType {
  faceId(name: 'FaceID'),
  fingerprint(name: 'Fingerprint'),
  touchId(name: 'TouchID'),
  none(name: ''),
  ;

  const BiometricType({
    required this.name,
  });

  final String name;
}

enum BiometricSetting {
  unknown,
  enabled,
  denied,
  unavailable,
}

class BiometricsHelper {
  static const String _biometricsDeniedKey = 'biometricsDeniedKey';

  static Future<BiometricType> getSupportedBiometricType() async {
    final isFingerprintAvailable =
        await LocalAuthInfo.instance.checkFingerprint();
    final isFaceIdAvailable = await LocalAuthInfo.instance.checkFaceId();
    if (isFaceIdAvailable && Platform.isIOS) {
      return BiometricType.faceId;
    } else if (isFingerprintAvailable) {
      return Platform.isAndroid
          ? BiometricType.fingerprint
          : BiometricType.touchId;
    } else {
      return BiometricType.none;
    }
  }

  static bool get isDenied =>
      getIt<SharedPreferences>().getBool(_biometricsDeniedKey) ?? false;

  static Future<bool> get isEnabled =>
      LocalAuthInfo.instance.canCheckBiometrics;

  static Future<void> deny() async =>
      getIt<SharedPreferences>().setBool(_biometricsDeniedKey, true);

  static Future<bool> enable() async {
    try {
      final hasAuthentication = await LocalAuthInfo.instance.authenticate();
      if (!hasAuthentication) {
        return false;
      }
      await LocalAuthInfo.instance.setCanCheckBiometrics(value: true);
      return true;
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      return false;
    }
  }

  static Future<BiometricSetting> getBiometricSetting() async {
    final isBiometricEnabled = await LocalAuthInfo.instance.canCheckBiometrics;
    if (isBiometricEnabled) {
      return BiometricSetting.enabled;
    }

    if (isDenied) {
      return BiometricSetting.denied;
    }

    final supportedBiometricType = await getSupportedBiometricType();

    if (supportedBiometricType == BiometricType.none) {
      return BiometricSetting.unavailable;
    }

    return BiometricSetting.unknown;
  }
}
