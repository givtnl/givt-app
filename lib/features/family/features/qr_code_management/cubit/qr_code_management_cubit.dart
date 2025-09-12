import 'dart:async';

import 'package:givt_app/features/family/features/qr_code_management/models/qr_code_management_uimodel.dart';
import 'package:givt_app/features/family/features/qr_code_management/repositories/qr_code_management_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

/// Cubit responsible for managing QR code management state.
/// Uses [QrCodeManagementRepository] for QR code operations.
class QrCodeManagementCubit extends CommonCubit<QrCodeManagementUIModel, QrCodeManagementCustom> {
  QrCodeManagementCubit(this._repository) : super(const BaseState.loading()) {
    _subscription = _repository.onQrCodesChanged().listen(_onQrCodesChanged);
    init();
  }

  final QrCodeManagementRepository _repository;
  StreamSubscription<void>? _subscription;
  int _selectedTabIndex = 0;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await super.close();
  }

  Future<void> init() async {
    await _repository.fetchQrCodes();
    _emitData();
  }

  void switchTab(int index) {
    _selectedTabIndex = index;
    _emitData();
  }

  Future<void> createQrCode(String name) async {
    await _repository.createQrCode(name);
    _emitData();
  }

  Future<void> activateQrCode(String qrCodeId) async {
    await _repository.activateQrCode(qrCodeId);
    _emitData();
  }

  Future<void> deactivateQrCode(String qrCodeId) async {
    await _repository.deactivateQrCode(qrCodeId);
    _emitData();
  }

  Future<void> downloadQrCode(String qrCodeId) async {
    // Emit custom event for download action
    emitCustom(QrCodeDownloadRequested(qrCodeId));
  }

  void _onQrCodesChanged(void _) {
    _emitData();
  }

  void _emitData() {
    final qrCodes = _repository.qrCodes;
    final activeQrCodes = qrCodes.where((qr) => qr.isActive).toList();
    final inactiveQrCodes = qrCodes.where((qr) => !qr.isActive).toList();

    emitData(
      QrCodeManagementUIModel(
        activeQrCodes: activeQrCodes,
        inactiveQrCodes: inactiveQrCodes,
        selectedTabIndex: _selectedTabIndex,
        isLoading: false,
      ),
    );
  }
}

/// Custom events for QR code management
sealed class QrCodeManagementCustom {
  const QrCodeManagementCustom();
}

class QrCodeDownloadRequested extends QrCodeManagementCustom {
  const QrCodeDownloadRequested(this.qrCodeId);
  final String qrCodeId;
}