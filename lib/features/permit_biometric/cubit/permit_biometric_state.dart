part of 'permit_biometric_cubit.dart';

enum PermitBiometricStatus {
  initial,
  checking,
  enabled,
  unavailable,
  denied,
  propose,
}

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

class PermitBiometricState extends Equatable {
  const PermitBiometricState._({
    required this.status,
    required this.biometricType,
    required this.permitBiometricRequest,
  });

  const PermitBiometricState.initial({
    required this.permitBiometricRequest,
  })  : status = PermitBiometricStatus.initial,
        biometricType = BiometricType.none;

  final PermitBiometricStatus status;
  final BiometricType biometricType;
  final PermitBiometricRequest permitBiometricRequest;

  bool get isAutoRedirectNeeded {
    return status == PermitBiometricStatus.denied ||
        status == PermitBiometricStatus.enabled ||
        status == PermitBiometricStatus.unavailable;
  }

  @override
  List<Object> get props => [status, biometricType, permitBiometricRequest];

  PermitBiometricState copyWith({
    PermitBiometricStatus? status,
    BiometricType? biometricType,
  }) {
    return PermitBiometricState._(
      status: status ?? this.status,
      biometricType: biometricType ?? this.biometricType,
      permitBiometricRequest: permitBiometricRequest,
    );
  }
}
