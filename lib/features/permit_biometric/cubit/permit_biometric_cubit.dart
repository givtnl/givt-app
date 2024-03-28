import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'permit_biometric_state.dart';

class PermitBiometricCubit extends Cubit<PermitBiometricState> {
  PermitBiometricCubit({
    required PermitBiometricRequest permitBiometricRequest,
  }) : super(
          PermitBiometricState.initial(
            permitBiometricRequest: permitBiometricRequest,
          ),
        );

  static const String _biometricsDeniedKey = 'biometricsDeniedKey';

  bool get _isDenied =>
      getIt<SharedPreferences>().getBool(_biometricsDeniedKey) ?? false;

  Future<BiometricType> _getSupportedBiometric() async {
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

  Future<void> checkBiometric() async {
    emit(state.copyWith(status: PermitBiometricStatus.checking));

    final isBiometricEnabled = await LocalAuthInfo.instance.canCheckBiometrics;
    if (isBiometricEnabled) {
      emit(state.copyWith(status: PermitBiometricStatus.enabled));
      return;
    }

    if (_isDenied) {
      emit(state.copyWith(status: PermitBiometricStatus.denied));
      return;
    }

    final supportedBiometricType = await _getSupportedBiometric();

    if (supportedBiometricType == BiometricType.none) {
      emit(state.copyWith(status: PermitBiometricStatus.unavailable));
      return;
    }

    emit(
      state.copyWith(
        status: PermitBiometricStatus.propose,
        biometricType: supportedBiometricType,
      ),
    );
  }

  Future<void> denyBiometric() async {
    //do not save decision during registration
    if (!state.permitBiometricRequest.isRegistration) {
      await getIt<SharedPreferences>().setBool(_biometricsDeniedKey, true);
    }
    emit(state.copyWith(status: PermitBiometricStatus.denied));
  }

  Future<void> enableBiometric() async {
    try {
      final hasAuthentication = await LocalAuthInfo.instance.authenticate();
      if (!hasAuthentication) {
        return;
      }
      await LocalAuthInfo.instance.setCanCheckBiometrics(value: true);
      emit(state.copyWith(status: PermitBiometricStatus.enabled));
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
    }
  }
}
