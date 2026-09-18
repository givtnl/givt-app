import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Android BLE scan preconditions for `FlutterBluePlus.startScan` with
/// `androidUsesFineLocation: true`.
enum AndroidBleLocationStatus {
  ready,
  serviceDisabled,
  permissionDenied,
  reducedAccuracy,
}

/// Checks Android location services, fine location permission, and precise
/// vs approximate accuracy before a BLE beacon scan.
///
/// Inject callbacks in tests. Production uses [Geolocator] and
/// [Permission.location] (ACCESS_FINE_LOCATION).
class AndroidBleLocationAccess {
  AndroidBleLocationAccess({
    bool Function()? isAndroid,
    Future<bool> Function()? isLocationServiceEnabled,
    Future<PermissionStatus> Function()? locationPermissionStatus,
    Future<PermissionStatus> Function()? requestLocationPermission,
    Future<LocationAccuracyStatus> Function()? locationAccuracy,
  }) : _isAndroid = isAndroid ?? _defaultIsAndroid,
       _isLocationServiceEnabled =
           isLocationServiceEnabled ?? Geolocator.isLocationServiceEnabled,
       _locationPermissionStatus =
           locationPermissionStatus ?? (() => Permission.location.status),
       _requestLocationPermission =
           requestLocationPermission ?? Permission.location.request,
       _locationAccuracy = locationAccuracy ?? Geolocator.getLocationAccuracy;

  final bool Function() _isAndroid;
  final Future<bool> Function() _isLocationServiceEnabled;
  final Future<PermissionStatus> Function() _locationPermissionStatus;
  final Future<PermissionStatus> Function() _requestLocationPermission;
  final Future<LocationAccuracyStatus> Function() _locationAccuracy;

  Future<AndroidBleLocationStatus>? _inFlight;

  static bool _defaultIsAndroid() => Platform.isAndroid;

  /// Returns [AndroidBleLocationStatus.ready] on iOS and other non-Android
  /// platforms. On Android, requests fine location once when status is denied.
  ///
  /// Concurrent callers share one in-flight check so `permission_handler`
  /// does not throw when init, resume, and adapter events overlap.
  Future<AndroidBleLocationStatus> ensureReady() {
    final inFlight = _inFlight;
    if (inFlight != null) {
      return inFlight;
    }
    final future = _ensureReady();
    _inFlight = future;
    return future.whenComplete(() {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    });
  }

  Future<AndroidBleLocationStatus> _ensureReady() async {
    if (!_isAndroid()) {
      return AndroidBleLocationStatus.ready;
    }

    final serviceEnabled = await _isLocationServiceEnabled();
    if (!serviceEnabled) {
      return AndroidBleLocationStatus.serviceDisabled;
    }

    var permission = await _locationPermissionStatus();
    if (permission.isDenied) {
      try {
        permission = await _requestLocationPermission();
      } on PlatformException {
        // Another permission dialog is already showing; use current status.
        permission = await _locationPermissionStatus();
      }
    }
    if (!permission.isGranted) {
      return AndroidBleLocationStatus.permissionDenied;
    }

    try {
      final accuracy = await _locationAccuracy();
      if (accuracy == LocationAccuracyStatus.reduced) {
        return AndroidBleLocationStatus.reducedAccuracy;
      }
    } on Object {
      return AndroidBleLocationStatus.permissionDenied;
    }

    return AndroidBleLocationStatus.ready;
  }
}
