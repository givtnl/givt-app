import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/utils/for_you_beacon_scan_session.dart';

void main() {
  group('ForYouBeaconScanSession', () {
    test('blocks duplicate starts while session is open', () {
      final session = ForYouBeaconScanSession();
      session.onScanStartAccepted();

      expect(session.shouldSkipStart(isScanningNow: false), isTrue);
      expect(session.shouldSkipStart(isScanningNow: true), isTrue);
    });

    test('allows start after platform reports scan stopped', () {
      final session = ForYouBeaconScanSession();
      session.onScanStartAccepted();
      session.setPlatformScanning(active: false);

      expect(session.shouldSkipStart(isScanningNow: false), isFalse);
    });

    test('coalesces concurrent start attempts into one pending start', () {
      final session = ForYouBeaconScanSession();

      expect(session.beginStartAttempt(), isTrue);
      expect(session.beginStartAttempt(), isFalse);

      session.endStartAttempt();
      expect(session.takePendingStart(), isTrue);
      expect(session.takePendingStart(), isFalse);
    });

    test('resume plus adapter-on path yields one in-flight start', () {
      final session = ForYouBeaconScanSession();
      var startScanCallCount = 0;

      void ensureScanning() {
        if (session.shouldSkipStart(isScanningNow: false)) {
          return;
        }
        if (!session.beginStartAttempt()) {
          return;
        }
        startScanCallCount++;
        session.onScanStartAccepted();
        session.endStartAttempt();
        if (session.takePendingStart()) {
          ensureScanning();
        }
      }

      ensureScanning();
      ensureScanning();

      expect(startScanCallCount, 1);
    });

    test('treats already-started native scan as an open session', () {
      final session = ForYouBeaconScanSession();
      session.onScanStartRejectedAsAlreadyRunning();

      expect(session.shouldSkipStart(isScanningNow: false), isTrue);
    });

    test('explicit stop clears session before restart', () {
      final session = ForYouBeaconScanSession();
      session.onScanStartAccepted();
      session.onExplicitStop();

      expect(session.shouldSkipStart(isScanningNow: false), isFalse);
    });
  });
}