import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/utils/for_you_beacon_scan_errors.dart';
import 'package:givt_app/features/give/utils/for_you_beacon_scan_start.dart';

void main() {
  group('startForYouBeaconScanWithAlreadyStartedRetry', () {
    test('already started triggers stop, settle, one retry startScan', () async {
      var startCalls = 0;
      var stopCalls = 0;
      Duration? settledFor;

      Future<void> startScan() async {
        startCalls++;
        if (startCalls == 1) {
          throw FlutterBluePlusException(
            ErrorPlatform.android,
            'startScan',
            androidScanFailedAlreadyStartedCode,
            'SCAN_FAILED_ALREADY_STARTED',
          );
        }
      }

      await startForYouBeaconScanWithAlreadyStartedRetry(
        startScan: startScan,
        stopOnPlatform: () async {
          stopCalls++;
          return true;
        },
        androidSettleAfterPlatformStop: true,
        delay: (d) async {
          settledFor = d;
        },
      );

      expect(startCalls, 2);
      expect(stopCalls, 1);
      expect(settledFor, const Duration(milliseconds: 150));
    });

    test('retry failure propagates for restart scheduling', () async {
      var startCalls = 0;

      await expectLater(
        startForYouBeaconScanWithAlreadyStartedRetry(
          startScan: () async {
            startCalls++;
            throw FlutterBluePlusException(
              ErrorPlatform.android,
              'startScan',
              androidScanFailedAlreadyStartedCode,
              'SCAN_FAILED_ALREADY_STARTED',
            );
          },
          stopOnPlatform: () async => true,
          androidSettleAfterPlatformStop: true,
          delay: (_) async {},
        ),
        throwsA(isA<FlutterBluePlusException>()),
      );

      expect(startCalls, 2);
    });

    test('skips settle when platform stop was not sent', () async {
      var startCalls = 0;
      var settleCalls = 0;

      await startForYouBeaconScanWithAlreadyStartedRetry(
        startScan: () async {
          startCalls++;
          if (startCalls == 1) {
            throw FlutterBluePlusException(
              ErrorPlatform.android,
              'startScan',
              androidScanFailedAlreadyStartedCode,
              'SCAN_FAILED_ALREADY_STARTED',
            );
          }
        },
        stopOnPlatform: () async => false,
        androidSettleAfterPlatformStop: true,
        delay: (_) async {
          settleCalls++;
        },
      );

      expect(startCalls, 2);
      expect(settleCalls, 0);
    });
  });
}
