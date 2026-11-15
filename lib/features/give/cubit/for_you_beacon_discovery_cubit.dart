import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/give/cubit/for_you_beacon_discovery_custom.dart';
import 'package:givt_app/features/give/cubit/for_you_beacon_discovery_uimodel.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/utils/android_ble_location_access.dart';
import 'package:givt_app/features/give/utils/for_you_beacon_scan_errors.dart';
import 'package:givt_app/features/give/utils/for_you_beacon_scan_session.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

/// Orchestrates BLE beacon discovery for the For You flow: scan sessions,
/// permission/adapter handling, org resolution, and navigation side effects.
class ForYouBeaconDiscoveryCubit
    extends
        CommonCubit<ForYouBeaconDiscoveryUIModel, ForYouBeaconDiscoveryCustom> {
  ForYouBeaconDiscoveryCubit({
    required CollectGroupRepository collectGroupRepository,
    AndroidBleLocationAccess? androidBleLocationAccess,
  }) : _collectGroupRepository = collectGroupRepository,
       _androidBleLocationAccess =
           androidBleLocationAccess ?? AndroidBleLocationAccess(),
       super(const BaseState.loading());

  static const Duration _scanTimeout = Duration(seconds: 30);

  /// Delay before restarting after a scan ends. Zero = restart as soon as the
  /// isScanning stream reports false (after debounce). Extra seconds are still
  /// added after consecutive startScan failures to ease Android throttling.
  static const Duration _baseRestartDelay = Duration.zero;

  /// Wait this long after the isScanning stream reports false before
  /// scheduling a restart — avoids transient false during startup / stream lag.
  static const Duration _scanStoppedDebounceDelay = Duration(milliseconds: 450);

  final CollectGroupRepository _collectGroupRepository;
  final AndroidBleLocationAccess _androidBleLocationAccess;

  ForYouFlowContext? _flowContext;
  bool _closing = false;
  bool _isProcessingBeacon = false;
  ForYouBeaconDiscoveryPhase _phase = ForYouBeaconDiscoveryPhase.searching;

  StreamSubscription<BluetoothAdapterState>? _adapterSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<bool>? _isScanningSubscription;
  Timer? _restartTimer;
  Timer? _scanStoppedDebounce;

  int _consecutiveScanFailures = 0;

  final ForYouBeaconScanSession _scanSession = ForYouBeaconScanSession();

  /// Prevents overlapping Android BLE/location `.request()` from init,
  /// resume, and the permission-dialog pause/resume cycle.
  bool _permissionsInFlight = false;

  void _logBle(String message) {
    if (kDebugMode) {
      LoggingInfo.instance.debug(
        '[ForYouBeacon] $message',
        methodName: 'ble',
      );
    }
  }

  /// Call once when the page is ready with the current flow context.
  Future<void> init(ForYouFlowContext flowContext) async {
    _flowContext = flowContext;

    if (await FlutterBluePlus.isSupported == false) {
      await _emitNavigateToList();
      return;
    }

    if (Platform.isAndroid) {
      await _requestAndroidPermissionsAndUpdatePhase();
    }

    _adapterSubscription = FlutterBluePlus.adapterState.listen(
      _onAdapterStateChanged,
      onError: (Object e, StackTrace s) {
        LoggingInfo.instance.error(
          'ForYou beacon adapterState error: $e',
          methodName: 'adapterState',
        );
      },
    );

    _isScanningSubscription = FlutterBluePlus.isScanning.listen(
      _onIsScanningChanged,
      onError: (Object e, StackTrace s) {
        LoggingInfo.instance.error(
          'ForYou beacon isScanning error: $e',
          methodName: 'isScanning',
        );
      },
    );

    _emitData();
  }

  /// Re-check permissions after returning from system settings (or similar).
  Future<void> onAppResumed() async {
    if (_closing || _flowContext == null) return;

    if (Platform.isAndroid) {
      if (!await _requestAndroidPermissionsAndUpdatePhase()) {
        return;
      }
      _setPhase(ForYouBeaconDiscoveryPhase.searching);
      if (FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on) {
        _ensureScanResultsSubscription();
        await _ensureScanning(reason: 'app_resumed_android');
      }
      return;
    }

    if (_phase == ForYouBeaconDiscoveryPhase.bluetoothPermissionSettings &&
        FlutterBluePlus.adapterStateNow == BluetoothAdapterState.on) {
      _setPhase(ForYouBeaconDiscoveryPhase.searching);
      _ensureScanResultsSubscription();
      await _ensureScanning(reason: 'app_resumed_ios');
    }
  }

  /// Opens system settings (Bluetooth / app permissions).
  Future<void> openSystemSettings() => openAppSettings();

  Future<void> _emitNavigateToList() async {
    await _teardownBle();
    _closing = true;
    final flow = _flowContext;
    if (flow != null) {
      emitCustom(ForYouBeaconNavigateToList(flow));
    }
  }

  /// Requests BLE (+ location) in one batched dialog when needed.
  /// Returns false when Bluetooth scan/connect was not granted (and sets
  /// the Bluetooth settings phase) or when location is not ready.
  Future<bool> _requestAndroidPermissionsAndUpdatePhase() async {
    if (_permissionsInFlight) {
      return false;
    }
    _permissionsInFlight = true;
    try {
      final granted = await _requestAndroidBlePermissions();
      if (!granted) {
        _setPhase(ForYouBeaconDiscoveryPhase.bluetoothPermissionSettings);
        return false;
      }
      return await _ensureAndroidLocationReady();
    } finally {
      _permissionsInFlight = false;
    }
  }

  Future<bool> _requestAndroidBlePermissions() async {
    if (await _hasAndroidBlePermissions()) {
      return true;
    }
    try {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
      final scan = statuses[Permission.bluetoothScan];
      final connect = statuses[Permission.bluetoothConnect];
      return (scan?.isGranted ?? false) && (connect?.isGranted ?? false);
    } on PlatformException catch (e) {
      LoggingInfo.instance.warning(
        'Android BLE permission request already running: $e',
        methodName: '_requestAndroidBlePermissions',
      );
      return _hasAndroidBlePermissions();
    }
  }

  Future<bool> _hasAndroidBlePermissions() async {
    if (!Platform.isAndroid) return true;
    final scan = await Permission.bluetoothScan.status;
    final connect = await Permission.bluetoothConnect.status;
    return scan.isGranted && connect.isGranted;
  }

  /// Returns true when Android location is ready for BLE scanning (or the
  /// platform is not Android). Sets a location UI phase and stops scanning
  /// when services, permission, or fine accuracy are missing.
  Future<bool> _ensureAndroidLocationReady() async {
    final status = await _androidBleLocationAccess.ensureReady();
    switch (status) {
      case AndroidBleLocationStatus.ready:
        return true;
      case AndroidBleLocationStatus.serviceDisabled:
        if (_phase != ForYouBeaconDiscoveryPhase.locationOff) {
          await AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.forYouLocationServiceOff,
          );
        }
        _setPhase(ForYouBeaconDiscoveryPhase.locationOff);
        await _stopScanSafe();
        return false;
      case AndroidBleLocationStatus.permissionDenied:
      case AndroidBleLocationStatus.reducedAccuracy:
        if (_phase != ForYouBeaconDiscoveryPhase.locationPermissionSettings) {
          await AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.forYouLocationPermissionDenied,
          );
        }
        _setPhase(ForYouBeaconDiscoveryPhase.locationPermissionSettings);
        await _stopScanSafe();
        return false;
    }
  }

  void _setPhase(ForYouBeaconDiscoveryPhase phase) {
    _phase = phase;
    _emitData();
  }

  void _emitData() {
    emitData(
      ForYouBeaconDiscoveryUIModel(phase: _phase),
    );
  }

  void _ensureScanResultsSubscription() {
    if (_scanResultsSubscription != null) {
      return;
    }
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(
      _onScanResults,
      onError: (Object e, StackTrace s) {
        if (isBleScanAlreadyStartedError(e)) {
          _scanSession.onScanStartRejectedAsAlreadyRunning();
          _logBle(
            'scanResults error: scan already active — keep subscription',
          );
          return;
        }
        LoggingInfo.instance.error(
          'ForYou beacon scanResults error: $e',
          methodName: 'scanResults',
        );
      },
    );
  }

  Future<void> _onAdapterStateChanged(BluetoothAdapterState state) async {
    if (_closing) return;

    _logBle(
      'adapterState=$state phase=$_phase isScanningNow='
      '${FlutterBluePlus.isScanningNow}',
    );

    switch (state) {
      case BluetoothAdapterState.on:
        if (Platform.isAndroid && !await _hasAndroidBlePermissions()) {
          _setPhase(ForYouBeaconDiscoveryPhase.bluetoothPermissionSettings);
          await _stopScanSafe();
          return;
        }
        // Location must be ready before searching so a location-blocked
        // screen does not flash the searching UI when adapter re-emits on.
        if (!await _ensureAndroidLocationReady()) {
          return;
        }
        _setPhase(ForYouBeaconDiscoveryPhase.searching);
        _ensureScanResultsSubscription();
        await _ensureScanning(reason: 'adapter_on');
      case BluetoothAdapterState.off:
        if (Platform.isAndroid) {
          try {
            await FlutterBluePlus.turnOn(timeout: 10);
            return;
          } on Object catch (e, s) {
            LoggingInfo.instance.error(
              'ForYou beacon turnOn failed: $e',
              methodName: 'turnOn',
            );
            LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
          }
        }
        await AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.forYouLocationServiceOff,
        );
        _setPhase(ForYouBeaconDiscoveryPhase.bluetoothOff);
        await _stopScanSafe();
      case BluetoothAdapterState.unauthorized:
        _setPhase(ForYouBeaconDiscoveryPhase.bluetoothPermissionSettings);
        await _stopScanSafe();
      case BluetoothAdapterState.unavailable:
        await AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.forYouLocationServiceOff,
        );
        _setPhase(ForYouBeaconDiscoveryPhase.bluetoothOff);
        await _stopScanSafe();
      case BluetoothAdapterState.unknown:
      case BluetoothAdapterState.turningOn:
      case BluetoothAdapterState.turningOff:
        break;
    }
  }

  void _onIsScanningChanged(bool isScanning) {
    _logBle(
      'isScanning stream: active=$isScanning isScanningNow='
      '${FlutterBluePlus.isScanningNow} phase=$_phase '
      'processingBeacon=$_isProcessingBeacon',
    );

    // FBP can emit false briefly before native scanning is stable; cubit
    // emitWithClear does not affect BLE. Debounce before scheduling restart.
    if (isScanning) {
      _scanSession.setPlatformScanning(active: true);
      _scanStoppedDebounce?.cancel();
      _scanStoppedDebounce = null;
      if (_restartTimer != null) {
        _restartTimer!.cancel();
        _restartTimer = null;
        _logBle('cancelled pending scan restart (isScanning true again)');
      }
      return;
    }

    if (_closing || _isProcessingBeacon) return;
    if (_phase != ForYouBeaconDiscoveryPhase.searching) return;
    if (FlutterBluePlus.isScanningNow) return;

    _scanStoppedDebounce?.cancel();
    _scanStoppedDebounce = Timer(_scanStoppedDebounceDelay, () {
      _scanStoppedDebounce = null;
      if (_closing || _isProcessingBeacon) return;
      if (_phase != ForYouBeaconDiscoveryPhase.searching) return;
      if (FlutterBluePlus.isScanningNow) {
        _logBle(
          'debounced scan-stopped: still scanning after debounce — skip '
          'scheduleRestart',
        );
        return;
      }
      _scanSession.setPlatformScanning(active: false);
      _scheduleScanRestart(reason: 'isScanning_stream_false');
    });
  }

  void _scheduleScanRestart({required String reason}) {
    if (_closing || _isProcessingBeacon) return;
    if (_phase != ForYouBeaconDiscoveryPhase.searching) return;

    _restartTimer?.cancel();
    final extraSeconds = _consecutiveScanFailures.clamp(0, 5);
    final delay = _baseRestartDelay + Duration(seconds: extraSeconds);
    _logBle(
      'scheduleRestart in ${delay.inMilliseconds}ms '
      '(failures=$_consecutiveScanFailures) reason=$reason',
    );
    _restartTimer = Timer(delay, () {
      _restartTimer = null;
      if (_closing || _isProcessingBeacon) return;
      unawaited(_ensureScanning(reason: 'timer_after_$reason'));
    });
  }

  /// Pass a short reason string for logs (e.g. adapter_on, timer, resolver).
  /// If the adapter re-emits while a scan is already running, FBP would
  /// stop then start again — the isScanningNow guard avoids that churn.
  Future<void> _ensureScanning({required String reason}) async {
    if (_closing || _isProcessingBeacon) return;
    if (_phase != ForYouBeaconDiscoveryPhase.searching) return;

    if (Platform.isAndroid && !await _hasAndroidBlePermissions()) {
      _setPhase(ForYouBeaconDiscoveryPhase.bluetoothPermissionSettings);
      return;
    }

    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
      _logBle('ensureScanning skip: adapter not on (reason=$reason)');
      return;
    }

    if (!await _ensureAndroidLocationReady()) {
      return;
    }

    // flutter_blue_plus startScan() stops an existing scan before starting a new
    // one. If adapterState re-emits [on] while a scan is already running
    // (common on some Android builds), we'd churn stopScan/startScan — guard.
    final isScanningNow = FlutterBluePlus.isScanningNow;
    if (_scanSession.shouldSkipStart(isScanningNow: isScanningNow)) {
      if (reason.startsWith('timer_after')) {
        _logBle(
          'ensureScanning skip: scan active or start in flight '
          '(reason=$reason, isScanningNow=$isScanningNow, '
          'sessionOpen=${_scanSession.sessionOpen})',
        );
      } else {
        _logBle(
          'ensureScanning skip: scan active or start in flight '
          '(reason=$reason) — avoids duplicate startScan',
        );
      }
      return;
    }

    if (!_scanSession.beginStartAttempt()) {
      _logBle(
        'ensureScanning skip: coalesced in-flight start (reason=$reason)',
      );
      return;
    }

    await _stopScanSafe();
    if (Platform.isAndroid &&
        (reason.startsWith('timer_after') ||
            reason == 'app_resumed_android' ||
            reason == 'coalesced_pending' ||
            reason.startsWith('resolver_') ||
            reason.startsWith('resolve_'))) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    _logBle('startScan begin reason=$reason');

    try {
      await FlutterBluePlus.startScan(
        timeout: _scanTimeout,
        androidUsesFineLocation: true,
      );
      _consecutiveScanFailures = 0;
      _scanSession.onScanStartAccepted();
      _logBle(
        'startScan invoked OK reason=$reason (returns before 30s timeout '
        'elapses; timeout stops scan on native side)',
      );
    } on Object catch (e, s) {
      if (isBleScanAlreadyStartedError(e)) {
        _consecutiveScanFailures = 0;
        _scanSession.onScanStartRejectedAsAlreadyRunning();
        _logBle(
          'startScan: native scan already active — reusing (reason=$reason)',
        );
        return;
      }
      _scanSession.onExplicitStop();
      _consecutiveScanFailures++;
      LoggingInfo.instance.error(
        'ForYou beacon startScan failed: $e',
        methodName: 'startScan',
      );
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      if (!await _ensureAndroidLocationReady()) {
        return;
      }
      _scheduleScanRestart(reason: 'startScan_failed');
    } finally {
      _scanSession.endStartAttempt();
      if (_scanSession.takePendingStart() &&
          !_closing &&
          !_isProcessingBeacon &&
          _phase == ForYouBeaconDiscoveryPhase.searching) {
        unawaited(_ensureScanning(reason: 'coalesced_pending'));
      }
      // Let isScanning / native catch up before another adapter_on can call
      // startScan (which would stop the scan that just started).
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
  }

  Future<void> _onScanResults(List<ScanResult> results) async {
    if (_closing || _isProcessingBeacon) return;

    for (final scanResult in results) {
      if (_closing || _isProcessingBeacon) return;

      if (scanResult.advertisementData.advName.isEmpty) continue;
      if (scanResult.advertisementData.serviceData.isEmpty) continue;
      if (scanResult.advertisementData.serviceUuids.isEmpty) continue;

      final serviceUuid = scanResult.advertisementData.serviceUuids.first;
      if (!scanResult.advertisementData.serviceData.containsKey(serviceUuid)) {
        continue;
      }

      if (scanResult.rssi < -69) continue;

      final hex = StringBuffer();
      for (final b in scanResult.advertisementData.serviceData[serviceUuid]!) {
        hex.write(sprintf('%02x', [b]));
      }
      final beaconData = hex.toString();

      final contains =
          beaconData.contains('61f7ed01') ||
          beaconData.contains('61f7ed02') ||
          beaconData.contains('61f7ed03');
      if (!contains) continue;

      final startIndex = beaconData.indexOf('61f7ed');
      if (startIndex < 0) continue;
      if (startIndex + 32 > beaconData.length) continue;

      final namespace = beaconData.substring(startIndex, startIndex + 20);
      final instance = beaconData.substring(startIndex + 20, startIndex + 32);
      final beaconId = '$namespace.$instance';

      _isProcessingBeacon = true;
      await _stopScanSafe();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await _resolveAndContinueOrNavigate(beaconId);
      return;
    }
  }

  Future<void> _resolveAndContinueOrNavigate(String beaconId) async {
    try {
      final collectGroup =
          await ForYouDiscoveryResolvers.resolveCollectGroupFromBeaconId(
            beaconId,
            collectGroupRepository: _collectGroupRepository,
          );

      if (collectGroup == null) {
        _isProcessingBeacon = false;
        await _ensureScanning(reason: 'resolver_null_resume');
        return;
      }

      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.forYouOrganisationSelected,
      );

      await _teardownBle();
      _closing = true;
      final flow = _flowContext;
      if (flow != null) {
        emitCustom(
          ForYouBeaconNavigateToConfirm(
            flow
                .copyWith(selectedOrganisation: collectGroup)
                .copyWith(entryMediumId: beaconId),
          ),
        );
      }
    } on Object catch (e, s) {
      LoggingInfo.instance.error(
        'ForYou beacon resolve failed: $e',
        methodName: 'resolveCollectGroupFromBeaconId',
      );
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
      _isProcessingBeacon = false;
      await _ensureScanning(reason: 'resolve_exception_resume');
    }
  }

  Future<void> _stopScanSafe() async {
    try {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
      _scanSession.onExplicitStop();
    } on Object catch (e, s) {
      LoggingInfo.instance.error(
        'ForYou beacon stopScan: $e',
        methodName: 'stopScan',
      );
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
  }

  Future<void> _teardownBle() async {
    _scanStoppedDebounce?.cancel();
    _scanStoppedDebounce = null;
    _restartTimer?.cancel();
    _restartTimer = null;
    _scanSession.reset();
    await _scanResultsSubscription?.cancel();
    _scanResultsSubscription = null;
    await _adapterSubscription?.cancel();
    _adapterSubscription = null;
    await _isScanningSubscription?.cancel();
    _isScanningSubscription = null;
    await _stopScanSafe();
  }

  @override
  Future<void> close() async {
    _closing = true;
    await _teardownBle();
    return super.close();
  }
}
