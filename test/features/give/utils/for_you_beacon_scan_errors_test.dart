import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/utils/for_you_beacon_scan_errors.dart';

void main() {
  group('isBleScanAlreadyStartedError', () {
    test('matches FlutterBluePlusException scan code 1', () {
      final error = FlutterBluePlusException(
        ErrorPlatform.android,
        'scan',
        androidScanFailedAlreadyStartedCode,
        'SCAN_FAILED_ALREADY_STARTED',
      );
      expect(isBleScanAlreadyStartedError(error), isTrue);
    });

    test('matches FlutterBluePlusException startScan description', () {
      final error = FlutterBluePlusException(
        ErrorPlatform.android,
        'startScan',
        99,
        'SCAN_FAILED_ALREADY_STARTED',
      );
      expect(isBleScanAlreadyStartedError(error), isTrue);
    });

    test('matches plain string errors', () {
      expect(
        isBleScanAlreadyStartedError(
          Exception('scan already started'),
        ),
        isTrue,
      );
    });

    test('returns false for unrelated errors', () {
      final error = FlutterBluePlusException(
        ErrorPlatform.android,
        'scan',
        2,
        'SCAN_FAILED_APPLICATION_REGISTRATION_FAILED',
      );
      expect(isBleScanAlreadyStartedError(error), isFalse);
    });
  });
}