import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/widgets/qr_scanner_zoom.dart';

void main() {
  group('QrScannerZoom.fromPinch', () {
    test('zooms in from rest', () {
      expect(
        QrScannerZoom.fromPinch(startScale: 0, gestureScale: 1.4),
        closeTo(0.2, 0.0001),
      );
    });

    test('zooms out from a mid scale', () {
      expect(
        QrScannerZoom.fromPinch(startScale: 0.5, gestureScale: 0.6),
        closeTo(0.3, 0.0001),
      );
    });

    test('clamps below zero', () {
      expect(
        QrScannerZoom.fromPinch(startScale: 0, gestureScale: 0.2),
        0,
      );
    });

    test('clamps above one', () {
      expect(
        QrScannerZoom.fromPinch(startScale: 0.8, gestureScale: 3),
        1,
      );
    });
  });

  group('QrScannerZoom.shouldApply', () {
    test('skips tiny deltas', () {
      expect(QrScannerZoom.shouldApply(0.2, 0.219), isFalse);
    });

    test('applies when delta reaches the threshold', () {
      expect(QrScannerZoom.shouldApply(0.2, 0.221), isTrue);
    });
  });

  group('QrScannerZoom.toggleTarget', () {
    test('zooms in from rest', () {
      expect(QrScannerZoom.toggleTarget(0), QrScannerZoom.togglePreset);
    });

    test('zooms in just under the rest threshold', () {
      expect(
        QrScannerZoom.toggleTarget(0.049),
        QrScannerZoom.togglePreset,
      );
    });

    test('resets when already zoomed', () {
      expect(QrScannerZoom.toggleTarget(0.5), 0);
      expect(QrScannerZoom.toggleTarget(1), 0);
    });

    test('zooms in from a camera that opened above zero', () {
      expect(
        QrScannerZoom.toggleTarget(0.25, opening: 0.25),
        QrScannerZoom.togglePreset,
      );
    });

    test('returns to the opening zoom when already zoomed in', () {
      expect(QrScannerZoom.toggleTarget(0.5, opening: 0.25), 0.25);
    });

    test('zooms to the maximum when the camera opened above the preset', () {
      expect(QrScannerZoom.toggleTarget(0.7, opening: 0.7), 1);
    });
  });

  group('QrScannerZoom.isAtRest', () {
    test('treats values under the threshold as rest', () {
      expect(QrScannerZoom.isAtRest(0), isTrue);
      expect(QrScannerZoom.isAtRest(0.049), isTrue);
      expect(QrScannerZoom.isAtRest(0.05), isFalse);
    });

    test('treats the camera opening zoom as rest', () {
      expect(QrScannerZoom.isAtRest(0.25, opening: 0.25), isTrue);
      expect(QrScannerZoom.isAtRest(0.29, opening: 0.25), isTrue);
      expect(QrScannerZoom.isAtRest(0.31, opening: 0.25), isFalse);
    });
  });
}
