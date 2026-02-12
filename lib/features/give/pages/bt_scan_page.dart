import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/dialogs/give_loading_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
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
  bool _isDisposed = false;

  StreamSubscription<List<ScanResult>>? _scanResultsStream;
  StreamSubscription<BluetoothAdapterState>? _adapterStateStream;
  StreamSubscription<bool>? _isScanningStream;

  // Every 30 seconds we will restart the scan for new devices
  final scanTimeout = 30;

  @override
  void initState() {
    super.initState();

    // Signal to GiveBloc that BT scan page is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        context.read<GiveBloc>().onBTScanPageInitialized();
      }
    });

    initBluetooth();
  }

  Future<void> startBluetoothScan() async {
    if (_isDisposed || !mounted) return;

    try {
      isSearching = true;
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: scanTimeout),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      LoggingInfo.instance.error('Failed to start Bluetooth scan: $e');
      isSearching = false;
    }
  }

  Future<void> stopBluetoothScan() async {
    if (_isDisposed) return;

    try {
      isSearching = false;
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
    } catch (e) {
      LoggingInfo.instance.error('Failed to stop Bluetooth scan: $e');
    }
  }

  Future<void> initBluetooth() async {
    if (_isDisposed) return;

    try {
      LoggingInfo.instance.info('initBluetooth');

      if (await FlutterBluePlus.isSupported == false) {
        LoggingInfo.instance.info('Bluetooth not supported on this device');
        return;
      }

      // Set listen method for scan results
      _scanResultsStream = FlutterBluePlus.scanResults.listen(
        _onPeripheralsDetectedData,
        onError: (dynamic e) {
          if (!_isDisposed) {
            LoggingInfo.instance.error(
              'Error while scanning for peripherals: $e',
            );
          }
        },
      );

      // Listen to scanning state changes
      _isScanningStream = FlutterBluePlus.isScanning.listen((event) async {
        if (_isDisposed || !mounted) return;

        if (event == false && !FlutterBluePlus.isScanningNow && isSearching) {
          LoggingInfo.instance.info('Restart Scan');
          await startBluetoothScan();
        }
      });

      // Listen to scan mode changes
      _adapterStateStream = FlutterBluePlus.adapterState.listen((
        BluetoothAdapterState state,
      ) async {
        if (_isDisposed || !mounted) return;

        switch (state) {
          case BluetoothAdapterState.on:
            if (!FlutterBluePlus.isScanningNow) {
              if (Platform.isAndroid) {
                final status = await Permission.bluetoothConnect.status;
                if (status.isDenied || status.isPermanentlyDenied) {
                  try {
                    final newStatus = await Permission.bluetoothConnect
                        .request();
                    if (newStatus.isGranted) {
                      await startBluetoothScan();
                      return;
                    }
                  } catch (_) {
                    if (!_isDisposed && mounted) {
                      await showBluetoothDeniedDialog();
                    }
                  }
                  if (!_isDisposed && mounted) {
                    await showBluetoothDeniedDialog();
                  }
                  return;
                }
              }
              LoggingInfo.instance.info('Start Scan');
              await startBluetoothScan();
            }
          case BluetoothAdapterState.unauthorized:
            LoggingInfo.instance.info('Bluetooth adapter is unauthorized');
            if (!_isDisposed && mounted) {
              await showBluetoothDeniedDialog();
            }
          case BluetoothAdapterState.unavailable:
          case BluetoothAdapterState.off:
            LoggingInfo.instance.info('Bluetooth adapter is off');
            if (Platform.isAndroid) {
              LoggingInfo.instance.info('Trying to turn it on...');
              try {
                await FlutterBluePlus.turnOn(timeout: 10);
              } catch (_) {
                // We can't turn on the bluetooth automatically, so show a dialog
                if (!_isDisposed && mounted) {
                  await showTurnOnBluetoothDialog();
                }
              }
            }
            if (Platform.isIOS) {
              LoggingInfo.instance.info('iOS User has Bluetooth off...');
              if (!_isDisposed && mounted) {
                await showTurnOnBluetoothDialog();
              }
            }
          // We don't want to handle other cases at the moment, so:
          // ignore: no_default_cases
          default:
            break;
        }
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (!_isDisposed && mounted) {
          setState(() {
            isVisible = true;
          });
        }
      });
    } catch (e) {
      LoggingInfo.instance.error(
        'Error in BT scan page: $e',
        methodName: 'initBluetooth',
      );
      if (!_isDisposed && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> showTurnOnBluetoothDialog() {
    if (_isDisposed || !mounted) return Future.value();

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
    if (_isDisposed || !mounted) return Future.value();

    return showDialog<void>(
      context: context,
      builder: (_) => WarningDialog(
        title: context.l10n.authoriseBluetooth,
        content:
            '''${context.l10n.authoriseBluetoothErrorMessage}\n ${context.l10n.authoriseBluetoothExtraText}''',
        onConfirm: () async {
          if (!_isDisposed && context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void _onPeripheralsDetectedData(List<ScanResult> results) {
    if (_isDisposed || !mounted || !isSearching) return;

    for (final scanResult in results) {
      if (_isDisposed || !mounted || !isSearching) return;

      if (scanResult.advertisementData.advName.isEmpty) {
        continue;
      }

      if (scanResult.advertisementData.serviceData.isEmpty) {
        continue;
      }
      if (scanResult.advertisementData.serviceUuids.isEmpty) {
        continue;
      }
      if (!scanResult.advertisementData.serviceData.containsKey(
        scanResult.advertisementData.serviceUuids.first,
      )) {
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
      for (final b
          in scanResult.advertisementData.serviceData[scanResult
              .advertisementData
              .serviceUuids
              .first]!) {
        hex.write(sprintf('%02x', [b]));
      }

      final beaconData = hex.toString();
      final contains =
          beaconData.contains('61f7ed01') ||
          beaconData.contains('61f7ed02') ||
          beaconData.contains('61f7ed03');

      if (!contains) {
        continue;
      }

      // Double-check we're still searching and not disposed
      if (_isDisposed || !mounted || !isSearching) return;

      // We found a valid beacon, stop scanning immediately
      isSearching = false;

      // Stop the scan asynchronously but don't wait for it
      FlutterBluePlus.stopScan().catchError((e) {
        LoggingInfo.instance.error('Error stopping scan: $e');
      });

      // Only process the beacon if we're still mounted and not disposed
      if (!_isDisposed && mounted) {
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

      // Exit after processing the first valid beacon
      return;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Signal to GiveBloc that BT scan page is being disposed
    try {
      context.read<GiveBloc>().onBTScanPageDisposed();
    } catch (e) {
      // Context might not be available during dispose
      LoggingInfo.instance.error('Could not signal disposal to GiveBloc: $e');
    }

    // Stop scanning first
    stopBluetoothScan();

    // Cancel all streams
    _scanResultsStream?.cancel();
    _adapterStateStream?.cancel();
    _isScanningStream?.cancel();

    // Clear references
    _scanResultsStream = null;
    _adapterStateStream = null;
    _isScanningStream = null;

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
    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: const GivtBackButtonFlat(),
        title: locals.giveWithYourPhone,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: BlocConsumer<GiveBloc, GiveState>(
          listener: (context, state) async {
            if (_isDisposed || !mounted) return;

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
                BodyMediumText(
                  locals.makeContact,
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
                  child: FunButton(
                    analyticsEvent: AmplitudeEvents.giveButtonPressed.toEvent(),
                    onTap: () async {
                      if (_isDisposed || !mounted) return;

                      GiveLoadingDialog.showGiveLoadingDialog(context);
                      if (orgName!.isNotEmpty) {
                        await stopBluetoothScan();
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
                    text: orgName.isEmpty
                        ? locals.giveDifferently
                        : locals.giveToNearestBeacon(
                            state.organisation.organisationName!,
                          ),
                  ),
                ),
                Visibility(
                  visible: isVisible && orgName.isNotEmpty,
                  child: FunTextButton(
                    analyticsEvent: AmplitudeEvents.giveButtonPressed.toEvent(),
                    onTap: () async {
                      if (_isDisposed || !mounted) return;

                      await stopBluetoothScan();
                      context.goNamed(
                        Pages.giveByList.name,
                        extra: context.read<GiveBloc>(),
                      );
                    },
                    text: locals.giveDifferently,
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
