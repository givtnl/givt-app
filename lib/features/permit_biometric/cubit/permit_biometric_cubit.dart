import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/utils/utils.dart';

part 'permit_biometric_state.dart';

class PermitBiometricCubit extends Cubit<PermitBiometricState> {
  PermitBiometricCubit({
    required PermitBiometricRequest permitBiometricRequest,
  }) : super(
          PermitBiometricState.initial(
            permitBiometricRequest: permitBiometricRequest,
          ),
        );

  Future<void> checkBiometric() async {
    emit(state.copyWith(status: PermitBiometricStatus.checking));

    if (await BiometricsHelper.isEnabled) {
      emit(state.copyWith(status: PermitBiometricStatus.enabled));
      return;
    }

    if (BiometricsHelper.isDenied) {
      emit(state.copyWith(status: PermitBiometricStatus.denied));
      return;
    }

    final supportedBiometricType =
        await BiometricsHelper.getSupportedBiometricType();

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
      await BiometricsHelper.deny();
    }
    emit(state.copyWith(status: PermitBiometricStatus.denied));
  }

  Future<void> enableBiometric() async {
    if (await BiometricsHelper.enable()) {
      emit(state.copyWith(status: PermitBiometricStatus.enabled));
    }
  }
}
