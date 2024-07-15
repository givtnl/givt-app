part of 'camera_cubit.dart';

enum CameraStatus {
  initial,
  requestPermission,
  permissionPermanentlyDeclined,
  permissionGranted,
  scanned,
  error
}

enum GalleryStatus {
  initial,
  requestPermission,
  permissionPermanentlyDeclined,
  permissionGranted
}

class CameraState extends Equatable {
  const CameraState({
    required this.isLoading,
    required this.qrValue,
    required this.feedback,
    required this.status,
    this.galleryStatus = GalleryStatus.initial,
  });
  final bool isLoading;
  final String qrValue;
  final String feedback;
  final CameraStatus status;
  final GalleryStatus galleryStatus;

  @override
  List<Object> get props =>
      [isLoading, qrValue, feedback, status, galleryStatus];

  CameraState copyWith({
    bool? isLoading,
    String? qrValue,
    String? feedback,
    CameraStatus? status,
    GalleryStatus? galleryStatus,
  }) {
    return CameraState(
      isLoading: isLoading ?? this.isLoading,
      qrValue: qrValue ?? this.qrValue,
      feedback: feedback ?? this.feedback,
      status: status ?? this.status,
      galleryStatus: galleryStatus ?? this.galleryStatus,
    );
  }

  static CameraState empty() {
    return const CameraState(
      isLoading: false,
      qrValue: '',
      feedback: 'No QR code scanned yet.',
      status: CameraStatus.initial,
    );
  }
}
