import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/qr_code.dart';

class QrCodeManagementUIModel extends Equatable {
  const QrCodeManagementUIModel({
    required this.activeQrCodes,
    required this.inactiveQrCodes,
    required this.selectedTabIndex,
    required this.isLoading,
  });

  final List<QrCode> activeQrCodes;
  final List<QrCode> inactiveQrCodes;
  final int selectedTabIndex;
  final bool isLoading;

  bool get isActiveTabSelected => selectedTabIndex == 0;
  bool get isInactiveTabSelected => selectedTabIndex == 1;

  List<QrCode> get currentQrCodes =>
      isActiveTabSelected ? activeQrCodes : inactiveQrCodes;

  @override
  List<Object?> get props => [
        activeQrCodes,
        inactiveQrCodes,
        selectedTabIndex,
        isLoading,
      ];
}