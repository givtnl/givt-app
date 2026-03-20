import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

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
  bool _isVisible = false;
  bool _isProcessing = false;

  StreamSubscription<List<ScanResult>>? _scanResultsStream;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scanResultsStream?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
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
          await _showBluetoothDeniedDialog();
          if (mounted) _goToList();
          return;
        }
      }
    }

    _scanResultsStream = FlutterBluePlus.scanResults.listen(
      _onScanResults,
      onError: (_) {},
    );

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 30),
      androidUsesFineLocation: true,
    );

    if (!_isDisposed && mounted) {
      setState(() => _isVisible = true);
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
      for (final b in scanResult
          .advertisementData.serviceData[serviceUuid]!) {
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
      final instance =
          beaconData.substring(startIndex + 20, startIndex + 32);
      final beaconId = '$namespace.$instance';

      _isProcessing = true;
      await FlutterBluePlus.stopScan();
      await _resolveAndNavigate(beaconId);
      return;
    }
  }

  Future<void> _resolveAndNavigate(String beaconId) async {
    try {
      final collectGroup = await ForYouDiscoveryResolvers
          .resolveCollectGroupFromBeaconId(beaconId);

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
        Pages.forYouGiving.name,
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

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const GivtBackButtonFlat(),
        title: Text(locals.giveWithYourPhone),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            BodyMediumText(
              locals.makeContact,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Image.asset('assets/images/givt_animation.gif'),
            if (_isVisible)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _goToList,
                  child: Text(locals.giveDifferently),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

