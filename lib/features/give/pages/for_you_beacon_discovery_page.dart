import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

/// Debug-only: simulated beacon id (2s auto-navigation on this screen).
/// Resolved with [ForYouDiscoveryResolvers.resolveCollectGroupFromBeaconId].
const String kDebugForYouBeaconSimulatedId = '61f7ed014e4c0817a000';

enum _BeaconDiscoveryState {
  searching,
  bluetoothOff,
  permissionDenied,
}

class ForYouBeaconDiscoveryPage extends StatefulWidget {
  const ForYouBeaconDiscoveryPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouBeaconDiscoveryPage> createState() =>
      _ForYouBeaconDiscoveryPageState();
}

class _ForYouBeaconDiscoveryPageState extends State<ForYouBeaconDiscoveryPage> {
  bool _isDisposed = false;
  bool _isProcessing = false;
  _BeaconDiscoveryState _state = _BeaconDiscoveryState.searching;

  StreamSubscription<BluetoothAdapterState>? _adapterStateStream;
  StreamSubscription<List<ScanResult>>? _scanResultsStream;
  Timer? _debugBeaconSimTimer;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
    if (kDebugMode) {
      _debugBeaconSimTimer = Timer(
        const Duration(seconds: 2),
        _debugSimulateBeaconAndNavigate,
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debugBeaconSimTimer?.cancel();
    _adapterStateStream?.cancel();
    _scanResultsStream?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> _debugSimulateBeaconAndNavigate() async {
    if (!kDebugMode || _isDisposed || !mounted || _isProcessing) {
      return;
    }
    _isProcessing = true;
    await FlutterBluePlus.stopScan();
    await _resolveAndNavigate(kDebugForYouBeaconSimulatedId);
  }

  Future<void> _initBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      if (mounted) _goToList();
      return;
    }

    // Request bluetooth permission (Android only).
    if (Platform.isAndroid) {
      final status = await Permission.bluetoothConnect.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        final newStatus = await Permission.bluetoothConnect.request();
        if (newStatus.isDenied || newStatus.isPermanentlyDenied) {
          if (!mounted) return;
          setState(() => _state = _BeaconDiscoveryState.permissionDenied);
          return;
        }
      }
    }

    // Subscribe to adapter state so the scan auto-starts whenever Bluetooth
    // becomes available — including after the OS permission popup is accepted
    // (iOS) or the user enables Bluetooth from Settings and returns.
    _adapterStateStream = FlutterBluePlus.adapterState.listen(
      _onAdapterStateChanged,
      onError: (_) {},
    );
  }

  Future<void> _onAdapterStateChanged(BluetoothAdapterState state) async {
    if (_isDisposed || !mounted) return;
    switch (state) {
      case BluetoothAdapterState.on:
        if (!FlutterBluePlus.isScanningNow && !_isProcessing) {
          setState(() => _state = _BeaconDiscoveryState.searching);
          _scanResultsStream ??= FlutterBluePlus.onScanResults.listen(
            _onScanResults,
            onError: (_) {},
          );
          await FlutterBluePlus.startScan(
            timeout: const Duration(seconds: 30),
            androidUsesFineLocation: true,
          );
        }
      case BluetoothAdapterState.off:
      case BluetoothAdapterState.unauthorized:
        if (mounted) {
          if (Platform.isAndroid) {
            try {
              await FlutterBluePlus.turnOn(timeout: 10);
            } catch (_) {
              // Failed to turn on automatically, show Bluetooth off state
            }
          }

          if (mounted) {
            await AnalyticsHelper.logEvent(
              eventName: AnalyticsEventName.forYouLocationServiceOff,
            );
            setState(() => _state = _BeaconDiscoveryState.bluetoothOff);
          }
        }
      default:
        break;
    }
  }

  Future<void> _showBluetoothDeniedDialog() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => WarningDialog(
        title: context.l10n.authoriseBluetooth,
        content:
            '''${context.l10n.authoriseBluetoothErrorMessage}\n ${context.l10n.authoriseBluetoothExtraText}''',
      ),
    );
  }

  Future<void> _onScanResults(List<ScanResult> results) async {
    if (_isDisposed || !mounted || _isProcessing) return;

    for (final scanResult in results) {
      if (_isDisposed || !mounted || _isProcessing) return;

      if (scanResult.advertisementData.advName.isEmpty) continue;
      if (scanResult.advertisementData.serviceData.isEmpty) continue;
      if (scanResult.advertisementData.serviceUuids.isEmpty) continue;

      final serviceUuid = scanResult.advertisementData.serviceUuids.first;
      if (!scanResult.advertisementData.serviceData.containsKey(serviceUuid)) {
        continue;
      }

      if (scanResult.rssi < -69) continue;

      // Convert service data bytes to a hex string.
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

      _isProcessing = true;
      await FlutterBluePlus.stopScan();
      await _resolveAndNavigate(beaconId);
      return;
    }
  }

  Future<void> _resolveAndNavigate(String beaconId) async {
    _debugBeaconSimTimer?.cancel();
    _debugBeaconSimTimer = null;
    try {
      final collectGroup =
          await ForYouDiscoveryResolvers.resolveCollectGroupFromBeaconId(
            beaconId,
          );

      if (!mounted) return;

      if (collectGroup == null) {
        _goToList();
        return;
      }

      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.forYouOrganisationSelected,
      );

      if (!mounted) return;
      context.goNamed(
        Pages.forYouOrganisationConfirm.name,
        extra: widget.flowContext
            .copyWith(selectedOrganisation: collectGroup)
            .toMap(),
      );
    } finally {
      _isProcessing = false;
    }
  }

  void _goToList() {
    if (!mounted) return;
    context.goNamed(
      Pages.forYouList.name,
      extra: widget.flowContext.toMap(),
    );
  }

  Future<void> _openBluetoothSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return FunScaffold(
      appBar: const FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: GivtBackButtonFlat(),
      ),
      body: switch (_state) {
        _BeaconDiscoveryState.searching => _SearchingBody(locals: locals),
        _BeaconDiscoveryState.bluetoothOff => _BluetoothOffBody(
          locals: locals,
          onOpenSettings: _openBluetoothSettings,
        ),
        _BeaconDiscoveryState.permissionDenied => _PermissionDeniedBody(
          locals: locals,
          onOpenSettings: _openBluetoothSettings,
        ),
      },
    );
  }
}

class _SearchingBody extends StatelessWidget {
  const _SearchingBody({required this.locals});

  final AppLocalizations locals;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.phoneWink(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.makeContact,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.forYouLocationSearchingBody,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}

class _BluetoothOffBody extends StatelessWidget {
  const _BluetoothOffBody({
    required this.locals,
    required this.onOpenSettings,
  });

  final AppLocalizations locals;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.bluetoothSettings(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.forYouBluetoothOffTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.forYouBluetoothOffBody,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FunButton(
          text: locals.forYouLocationOpenSettings,
          analyticsEvent: AnalyticsEvent(
            AnalyticsEventName.forYouLocationOpenSettingsTapped,
          ),
          onTap: onOpenSettings,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PermissionDeniedBody extends StatelessWidget {
  const _PermissionDeniedBody({
    required this.locals,
    required this.onOpenSettings,
  });

  final AppLocalizations locals;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FunIconGivy.bluetoothSettings(circleSize: 140),
        const SizedBox(height: 28),
        TitleLargeText(
          locals.authoriseBluetooth,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        BodyMediumText(
          locals.authoriseBluetoothErrorMessage,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FunButton(
          text: locals.forYouLocationOpenSettings,
          analyticsEvent: AnalyticsEvent(
            AnalyticsEventName.forYouLocationOpenSettingsTapped,
          ),
          onTap: onOpenSettings,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
