import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Android scan failure code for SCAN_FAILED_ALREADY_STARTED (API value 1).
const int androidScanFailedAlreadyStartedCode = 1;

/// Whether [error] indicates the platform BLE scan is already active.
bool isBleScanAlreadyStartedError(Object error) {
  if (error is FlutterBluePlusException) {
    if (error.function == 'scan' || error.function == 'startScan') {
      final code = error.code;
      if (code == androidScanFailedAlreadyStartedCode) {
        return true;
      }
      final description = error.description?.toUpperCase() ?? '';
      if (description.contains('SCAN_FAILED_ALREADY_STARTED') ||
          description.contains('ALREADY_STARTED')) {
        return true;
      }
    }
  }
  final message = error.toString().toUpperCase();
  return message.contains('SCAN_FAILED_ALREADY_STARTED') ||
      message.contains('ALREADY_STARTED') ||
      message.contains('SCAN ALREADY STARTED');
}