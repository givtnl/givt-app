import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/dialogs/give_loading_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

class BTScanPage extends StatefulWidget {
  const BTScanPage({
    super.key,
  });

  @override
  State<BTScanPage> createState() => _BTScanPageState();
}

class _BTScanPageState extends State<BTScanPage> {
  bool isVisible = false;
  bool isSearching = false;

  StreamSubscription<List<ScanResult>>? adapterStateStream;
  StreamSubscription<BluetoothAdapterState>? scanResultsStream;

  // Every 30 seconds we will restart the scan for new devices
  final scanTimeout = 30;

  @override
  void initState() {
    super.initState();

    initBluetooth();
  }

  Future<void> startBluetoothScan() async {
    isSearching = true;
    await FlutterBluePlus.startScan(
      timeout: Duration(seconds: scanTimeout),
      androidUsesFineLocation: true,
    );
  }

  Future<void> initBluetooth() async {
    try {
      LoggingInfo.instance.info('initBluetooth');

      if (await FlutterBluePlus.isSupported == false) {
        LoggingInfo.instance.info('Bluetooth not supported on this device');
        return;
      }

      // Set listen method for scan results
      adapterStateStream = FlutterBluePlus.scanResults.listen(
        _onPeripheralsDetectedData,
        onError: (dynamic e) {
          LoggingInfo.instance
              .error('Error while scanning for peripherals: $e');
        },
      );

      FlutterBluePlus.isScanning.listen((event) async {
        if (event == false && !FlutterBluePlus.isScanningNow && isSearching) {
          LoggingInfo.instance.info('Restart Scan');
          await startBluetoothScan();
        }
      });

      // Listen to scan mode changes
      scanResultsStream = FlutterBluePlus.adapterState
          .listen((BluetoothAdapterState state) async {
        switch (state) {
          case BluetoothAdapterState.on:
            if (!FlutterBluePlus.isScanningNow) {
              if (Platform.isAndroid) {
                final status = await Permission.bluetoothConnect.status;
                if (status.isDenied || status.isPermanentlyDenied) {
                  try {
                    final newStatus =
                        await Permission.bluetoothConnect.request();
                    if (newStatus.isGranted) {
                      await startBluetoothScan();
                      return;
                    }
                  } catch (_) {
                    await showBluetoothDeniedDialog();
                  }
                  await showBluetoothDeniedDialog();
                  return;
                }
              }
              LoggingInfo.instance.info('Start Scan');
              await startBluetoothScan();
            }
          case BluetoothAdapterState.unauthorized:
            LoggingInfo.instance.info('Bluetooth adapter is unauthorized');
            if (!mounted) {
              return;
            }
            await showBluetoothDeniedDialog();
          case BluetoothAdapterState.unavailable:
          case BluetoothAdapterState.off:
            LoggingInfo.instance.info('Bluetooth adapter is off');
            if (Platform.isAndroid) {
              LoggingInfo.instance.info('Trying to turn it on...');
              try {
                await FlutterBluePlus.turnOn(timeout: 10);
              } catch (_) {
                // We can't turn on the bluetooth automatically, so show a dialog
                await showTurnOnBluetoothDialog();
              }
            }
            if (Platform.isIOS) {
              LoggingInfo.instance.info('iOS User has Bluetooth off...');
              if (!context.mounted) {
                return;
              }
              await showTurnOnBluetoothDialog();
            }
          // We don't want to handle other cases at the moment, so:
          // ignore: no_default_cases
          default:
            break;
        }
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (!mounted) {
          return;
        }
        setState(() {
          isVisible = true;
        });
      });
    } catch (e) {
      LoggingInfo.instance
          .error('Error in BT scan page: $e', methodName: 'initBluetooth');
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> showTurnOnBluetoothDialog() {
    return showDialog<void>(
      context: context,
      builder: (_) => WarningDialog(
        title: context.l10n.turnOnBluetooth,
        content: context.l10n.bluetoothErrorMessage,
        onConfirm: () async {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> showBluetoothDeniedDialog() {
    return showDialog<void>(
      context: context,
      builder: (_) => WarningDialog(
        title: context.l10n.authoriseBluetooth,
        content:
            '''${context.l10n.authoriseBluetoothErrorMessage}\n ${context.l10n.authoriseBluetoothExtraText}''',
        onConfirm: () async {
          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _onPeripheralsDetectedData(List<ScanResult> results) {
    for (final scanResult in results) {
      if (scanResult.advertisementData.advName.isEmpty) {
        continue;
      }

      if (scanResult.advertisementData.serviceData.isEmpty) {
        continue;
      }
      if (scanResult.advertisementData.serviceUuids.isEmpty) {
        continue;
      }
      if (!scanResult.advertisementData.serviceData
          .containsKey(scanResult.advertisementData.serviceUuids.first)) {
        continue;
      }

      if (scanResult.rssi < -69) {
        continue;
      }

      if (!mounted) {
        return;
      }

      // Check if its really a Givt beacon
      final hex = StringBuffer();
      for (final b in scanResult.advertisementData
          .serviceData[scanResult.advertisementData.serviceUuids.first]!) {
        hex.write(sprintf('%02x', [b]));
      }

      final beaconData = hex.toString();
      final contains = beaconData.contains('61f7ed01') ||
          beaconData.contains('61f7ed02') ||
          beaconData.contains('61f7ed03');

      if (!contains) {
        continue;
      }

      // When not searching for a beacon we wanna
      // ignore the rest of the scan results
      if (!isSearching) {
        return;
      }

      // We might have found something, so stop the scan
      isSearching = false;
      FlutterBluePlus.stopScan();

      context.read<GiveBloc>().add(
            GiveBTBeaconScanned(
              userGUID: context.read<AuthCubit>().state.user.guid,
              macAddress: scanResult.device.remoteId.toString(),
              rssi: scanResult.rssi,
              serviceUUID: scanResult.advertisementData.serviceUuids.first,
              serviceData: scanResult.advertisementData.serviceData,
              beaconData: beaconData,
            ),
          );
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    adapterStateStream?.cancel();
    scanResultsStream?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);

    /// Because the GIF has this color we need to set
    /// the background color to the same color
    /// otherwise we will see a white background
    const backgroundColor = Color(0xFFFBFBFB);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(locals.giveWithYourPhone),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: BlocConsumer<GiveBloc, GiveState>(
          listener: (context, state) async {
            if (state.status == GiveStatus.loading &&
                !FlutterBluePlus.isScanningNow &&
                isSearching) {
              LoggingInfo.instance.info('Restart Scan');
              await startBluetoothScan();
            }
          },
          builder: (context, state) {
            var orgName = state.organisation.organisationName;
            orgName ??= '';
            return Column(
              children: [
                SizedBox(height: size.height * 0.03),
                Text(
                  locals.makeContact,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Container(
                  height: size.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/images/givt_animation.gif'),
                ),
                Expanded(child: Container()),
                Visibility(
                  visible: isVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        GiveLoadingDialog.showGiveLoadingDialog(context);
                        if (orgName!.isNotEmpty) {
                          isSearching = false;
                          FlutterBluePlus.stopScan();
                          context.read<GiveBloc>().add(
                                GiveToLastOrganisation(
                                  context.read<AuthCubit>().state.user.guid,
                                ),
                              );
                          return;
                        }
                        context.goNamed(
                          Pages.giveByList.name,
                          extra: context.read<GiveBloc>(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.givtBlue,
                      ),
                      child: Text(
                        orgName.isEmpty
                            ? locals.giveDifferently
                            : locals.giveToNearestBeacon(
                                state.organisation.organisationName!,
                              ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isVisible && orgName.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: TextButton(
                      onPressed: () {
                        isSearching = false;
                        FlutterBluePlus.stopScan();
                        context.goNamed(
                          Pages.giveByList.name,
                          extra: context.read<GiveBloc>(),
                        );
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(locals.giveDifferently),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
