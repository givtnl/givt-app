import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/features/give/utils/android_ble_location_access.dart';
import 'package:givt_app/features/give/utils/permission_request_guard.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  group('AndroidBleLocationAccess.ensureReady', () {
    setUp(PermissionRequestGuard.reset);
    tearDown(PermissionRequestGuard.reset);
    test('returns ready when not Android', () async {
      var requested = false;
      final access = AndroidBleLocationAccess(
        isAndroid: () => false,
        isLocationServiceEnabled: () async => false,
        locationPermissionStatus: () async => PermissionStatus.denied,
        requestLocationPermission: () async {
          requested = true;
          return PermissionStatus.denied;
        },
        locationAccuracy: () async => LocationAccuracyStatus.reduced,
      );

      expect(await access.ensureReady(), AndroidBleLocationStatus.ready);
      expect(requested, isFalse);
    });

    test('returns serviceDisabled when location services are off', () async {
      var requested = false;
      final access = AndroidBleLocationAccess(
        isAndroid: () => true,
        isLocationServiceEnabled: () async => false,
        locationPermissionStatus: () async => PermissionStatus.granted,
        requestLocationPermission: () async {
          requested = true;
          return PermissionStatus.granted;
        },
        locationAccuracy: () async => LocationAccuracyStatus.precise,
      );

      expect(
        await access.ensureReady(),
        AndroidBleLocationStatus.serviceDisabled,
      );
      expect(requested, isFalse);
    });

    test('returns permissionDenied when request stays denied', () async {
      var requested = false;
      final access = AndroidBleLocationAccess(
        isAndroid: () => true,
        isLocationServiceEnabled: () async => true,
        locationPermissionStatus: () async => PermissionStatus.denied,
        requestLocationPermission: () async {
          requested = true;
          return PermissionStatus.denied;
        },
        locationAccuracy: () async => LocationAccuracyStatus.precise,
      );

      expect(
        await access.ensureReady(),
        AndroidBleLocationStatus.permissionDenied,
      );
      expect(requested, isTrue);
    });

    test('does not request when permanently denied', () async {
      var requested = false;
      final access = AndroidBleLocationAccess(
        isAndroid: () => true,
        isLocationServiceEnabled: () async => true,
        locationPermissionStatus: () async =>
            PermissionStatus.permanentlyDenied,
        requestLocationPermission: () async {
          requested = true;
          return PermissionStatus.permanentlyDenied;
        },
        locationAccuracy: () async => LocationAccuracyStatus.precise,
      );

      expect(
        await access.ensureReady(),
        AndroidBleLocationStatus.permissionDenied,
      );
      expect(requested, isFalse);
    });

    test(
      'returns reducedAccuracy when only approximate location is granted',
      () async {
        final access = AndroidBleLocationAccess(
          isAndroid: () => true,
          isLocationServiceEnabled: () async => true,
          locationPermissionStatus: () async => PermissionStatus.granted,
          requestLocationPermission: () async => PermissionStatus.granted,
          locationAccuracy: () async => LocationAccuracyStatus.reduced,
        );

        expect(
          await access.ensureReady(),
          AndroidBleLocationStatus.reducedAccuracy,
        );
      },
    );

    test('returns ready after a successful permission request', () async {
      var status = PermissionStatus.denied;
      final access = AndroidBleLocationAccess(
        isAndroid: () => true,
        isLocationServiceEnabled: () async => true,
        locationPermissionStatus: () async => status,
        requestLocationPermission: () async {
          status = PermissionStatus.granted;
          return PermissionStatus.granted;
        },
        locationAccuracy: () async => LocationAccuracyStatus.precise,
      );

      expect(await access.ensureReady(), AndroidBleLocationStatus.ready);
    });

    test('returns ready when fine location is already granted', () async {
      var requested = false;
      final access = AndroidBleLocationAccess(
        isAndroid: () => true,
        isLocationServiceEnabled: () async => true,
        locationPermissionStatus: () async => PermissionStatus.granted,
        requestLocationPermission: () async {
          requested = true;
          return PermissionStatus.granted;
        },
        locationAccuracy: () async => LocationAccuracyStatus.precise,
      );

      expect(await access.ensureReady(), AndroidBleLocationStatus.ready);
      expect(requested, isFalse);
    });

    test('returns permissionDenied when accuracy check throws', () async {
      final access = AndroidBleLocationAccess(
        isAndroid: () => true,
        isLocationServiceEnabled: () async => true,
        locationPermissionStatus: () async => PermissionStatus.granted,
        requestLocationPermission: () async => PermissionStatus.granted,
        locationAccuracy: () async => throw Exception('permissionDenied'),
      );

      expect(
        await access.ensureReady(),
        AndroidBleLocationStatus.permissionDenied,
      );
    });

    test(
      'concurrent ensureReady requests location permission only once',
      () async {
        var requests = 0;
        var status = PermissionStatus.denied;
        final access = AndroidBleLocationAccess(
          isAndroid: () => true,
          isLocationServiceEnabled: () async => true,
          locationPermissionStatus: () async => status,
          requestLocationPermission: () async {
            requests++;
            await Future<void>.delayed(const Duration(milliseconds: 30));
            status = PermissionStatus.granted;
            return PermissionStatus.granted;
          },
          locationAccuracy: () async => LocationAccuracyStatus.precise,
        );

        final results = await Future.wait([
          access.ensureReady(),
          access.ensureReady(),
        ]);

        expect(
          results,
          [
            AndroidBleLocationStatus.ready,
            AndroidBleLocationStatus.ready,
          ],
        );
        expect(requests, 1);
      },
    );

    test(
      're-reads status when a concurrent PlatformException is thrown',
      () async {
        var status = PermissionStatus.denied;
        final access = AndroidBleLocationAccess(
          isAndroid: () => true,
          isLocationServiceEnabled: () async => true,
          locationPermissionStatus: () async => status,
          requestLocationPermission: () async {
            status = PermissionStatus.granted;
            throw PlatformException(
              code: 'PermissionHandler.PermissionManager',
              message: PermissionRequestGuard.concurrentRequestMessage,
            );
          },
          locationAccuracy: () async => LocationAccuracyStatus.precise,
        );

        expect(await access.ensureReady(), AndroidBleLocationStatus.ready);
      },
    );
  });
}
