import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Android scan failure code for SCAN_FAILED_ALREADY_STARTED (API value 1).
const int androidScanFailedAlreadyStartedCode = 1;

/// Whether [error] indicates the platform BLE scan is already active.
bool isBleScanAlreadyStartedError(Object error) {
  if (error is! FlutterBluePlusException) {
    return false;
  }
  if (error.function != 'scan' && error.function != 'startScan') {
    return false;
  }
  if (error.code == androidScanFailedAlreadyStartedCode) {
    return true;
  }
  final description = error.description?.toUpperCase() ?? '';
  return description.contains('SCAN_FAILED_ALREADY_STARTED') ||
      description.contains('ALREADY_STARTED');
}