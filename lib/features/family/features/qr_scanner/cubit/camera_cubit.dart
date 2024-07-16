import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState.empty());

  static const Duration _permissionDialogDelay = Duration(milliseconds: 300);
  Future<void> checkGalleryPermission() async {
    resetPermissionStatuses();
    final status = await Permission.photos.status;
    //delay is from design
    await Future<void>.delayed(_permissionDialogDelay);

    if (status.isDenied) {
      emit(state.copyWith(galleryStatus: GalleryStatus.requestPermission));
      return;
    }

    if (status.isPermanentlyDenied) {
      emit(
        state.copyWith(
          galleryStatus: GalleryStatus.permissionPermanentlyDeclined,
        ),
      );
      return;
    }
    emit(state.copyWith(galleryStatus: GalleryStatus.permissionGranted));
  }

  Future<void> checkCameraPermission() async {
    resetPermissionStatuses();
    final status = await Permission.camera.status;
    //delay is from design
    await Future<void>.delayed(_permissionDialogDelay);

    if (status.isDenied) {
      emit(state.copyWith(status: CameraStatus.requestPermission));
      return;
    }

    if (status.isPermanentlyDenied) {
      emit(state.copyWith(status: CameraStatus.permissionPermanentlyDeclined));
      return;
    }
    emit(state.copyWith(status: CameraStatus.permissionGranted));
  }

  Future<void> grantAccess() async {
    emit(state.copyWith(status: CameraStatus.permissionGranted));
  }

  Future<void> scanQrCode(BarcodeCapture barcode) async {
    if (barcode.barcodes.isEmpty) {
      emit(
        state.copyWith(
          status: CameraStatus.initial,
          feedback: 'No QR code scanned yet.',
        ),
      );

      return;
    }

    for (final barcode in barcode.barcodes) {
      if (barcode.rawValue == null) continue;
      final barcodeUri = Uri.parse(barcode.rawValue!);

      if (barcodeUri.queryParameters['code'] == null) continue;
      final mediumId = barcodeUri.queryParameters['code']!;
      emit(
        state.copyWith(
          status: CameraStatus.scanned,
          qrValue: mediumId,
          feedback: 'QR code scanned successfully!\nLoading data...',
        ),
      );
      return;
    }
    emit(
      state.copyWith(status: CameraStatus.error, feedback: 'Invalid QR Code'),
    );
  }

  void resetPermissionStatuses() {
    emit(
      state.copyWith(
        status: CameraStatus.initial,
        galleryStatus: GalleryStatus.initial,
      ),
    );
  }
}
