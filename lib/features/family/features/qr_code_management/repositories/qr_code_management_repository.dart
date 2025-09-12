import 'dart:async';

import 'package:givt_app/shared/models/qr_code.dart';

abstract class QrCodeManagementRepository {
  List<QrCode> get qrCodes;
  Stream<void> onQrCodesChanged();
  Future<void> fetchQrCodes();
  Future<void> createQrCode(String name);
  Future<void> activateQrCode(String qrCodeId);
  Future<void> deactivateQrCode(String qrCodeId);
}

class QrCodeManagementRepositoryImpl implements QrCodeManagementRepository {
  QrCodeManagementRepositoryImpl();

  final StreamController<void> _qrCodesStreamController = StreamController.broadcast();
  List<QrCode> _qrCodes = [];

  @override
  List<QrCode> get qrCodes => List.unmodifiable(_qrCodes);

  @override
  Stream<void> onQrCodesChanged() => _qrCodesStreamController.stream;

  @override
  Future<void> fetchQrCodes() async {
    // TODO: Implement actual API call
    // For now, using mock data
    await Future.delayed(const Duration(milliseconds: 500));
    
    _qrCodes = [
      QrCode(
        name: 'Main Donation QR',
        instance: 'main.001',
        isActive: true,
      ),
      QrCode(
        name: 'Event QR Code',
        instance: 'event.002',
        isActive: true,
      ),
      QrCode(
        name: 'Legacy QR Code',
        instance: 'legacy.003',
        isActive: false,
      ),
      QrCode(
        name: 'Test QR Code',
        instance: 'test.004',
        isActive: false,
      ),
    ];
    
    _qrCodesStreamController.add(null);
  }

  @override
  Future<void> createQrCode(String name) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    final newQrCode = QrCode(
      name: name,
      instance: 'new.${DateTime.now().millisecondsSinceEpoch}',
      isActive: true,
    );
    
    _qrCodes = [..._qrCodes, newQrCode];
    _qrCodesStreamController.add(null);
  }

  @override
  Future<void> activateQrCode(String qrCodeId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    _qrCodes = _qrCodes.map((qr) {
      if (qr.instance == qrCodeId) {
        return qr.copyWith(isActive: true);
      }
      return qr;
    }).toList();
    
    _qrCodesStreamController.add(null);
  }

  @override
  Future<void> deactivateQrCode(String qrCodeId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    
    _qrCodes = _qrCodes.map((qr) {
      if (qr.instance == qrCodeId) {
        return qr.copyWith(isActive: false);
      }
      return qr;
    }).toList();
    
    _qrCodesStreamController.add(null);
  }
}