import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:sprintf/sprintf.dart';

class BTScanPage extends StatefulWidget {
  const BTScanPage({super.key});

  @override
  State<BTScanPage> createState() => _BTScanPageState();
}

class _BTScanPageState extends State<BTScanPage> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    initBluetooth();
  }

  Future<void> initBluetooth() async {
    await LoggingInfo.instance.info('initBluetooth');

    if (await FlutterBluePlus.isSupported == false) {
      await LoggingInfo.instance.info('Bluetooth not supported on this device');
      return;
    }

    // Set listen method for scan results
    FlutterBluePlus.scanResults.listen(
      _onPeripheralsDetectedData,
      onError: (e) {
        LoggingInfo.instance.error('Error while scanning for peripherals: $e');
      },
    );

    // Listen to scan mode changes
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      switch (state) {
        case BluetoothAdapterState.on:
          await FlutterBluePlus.startScan(
            timeout: const Duration(seconds: 30),
            androidUsesFineLocation: true,
          );
        case BluetoothAdapterState.unauthorized:
          await LoggingInfo.instance.info('Bluetooth adapter is unauthorized');
        case BluetoothAdapterState.off:
          await LoggingInfo.instance.info('Bluetooth adapter is off');
          if (Platform.isAndroid) {
            await LoggingInfo.instance.info('Trying to turn it on...');
            await FlutterBluePlus.turnOn();
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
        _isVisible = true;
      });
    });
  }

  void _onPeripheralsDetectedData(List<ScanResult> results) {
    for (final scanResult in results) {
      if (scanResult.advertisementData.localName.isEmpty) {
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

      // After some feedback from customer we decided to slightly change the RSSI value to support a bigger range
      if (scanResult.rssi < -70) {
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
        return;
      }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(locals.giveWithYourPhone),
      ),
      body: Center(
        child: BlocConsumer<GiveBloc, GiveState>(
          listener: (context, state) {},
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
                  visible: _isVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (orgName!.isNotEmpty) {
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
                  visible: _isVisible && orgName.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: TextButton(
                      onPressed: () => context.goNamed(
                        Pages.giveByList.name,
                        extra: context.read<GiveBloc>(),
                      ),
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
