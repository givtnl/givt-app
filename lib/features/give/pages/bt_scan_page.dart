import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/pages/giving_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class BTScanPage extends StatefulWidget {
  const BTScanPage({super.key});

  @override
  State<BTScanPage> createState() => _BTScanPageState();
}

class _BTScanPageState extends State<BTScanPage> {
  late FlutterBluePlus flutterBlue;

  @override
  void initState() {
    super.initState();
    flutterBlue = FlutterBluePlus.instance;
    flutterBlue
      ..startScan(timeout: const Duration(seconds: 40))
      ..scanResults.listen((results) {}).onData(_onPeripheralsDetectedData);
  }

  void _onPeripheralsDetectedData(List<ScanResult> results) {
    for (final scanResult in results) {
      /// Givt beacons have a name, manufacturer data, service data,
      /// and a service UUID.
      if (scanResult.device.name.isEmpty) {
        continue;
      }
      if (scanResult.advertisementData.manufacturerData.isNotEmpty) {
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

      if (scanResult.rssi < -75 || scanResult.rssi < -67) {
        continue;
      }

      if (!mounted) {
        return;
      }
      context.read<GiveBloc>().add(
            GiveBTBeaconScanned(
              userGUID:
                  (context.read<AuthCubit>().state as AuthSuccess).user.guid,
              macAddress: scanResult.device.id.toString(),
              rssi: scanResult.rssi,
              serviceUUID: scanResult.advertisementData.serviceUuids.first,
              serviceData: scanResult.advertisementData.serviceData,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(locals.giveWithYourPhone),
      ),
      body: Center(
        child: BlocConsumer<GiveBloc, GiveState>(
          listener: (context, state) {
            if (state.status == GiveStatus.readyToGive) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: context.read<GiveBloc>(),
                    child: const GivingPage(),
                  ),
                  fullscreenDialog: true,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  locals.makeContact,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/images/givt_animation.gif'),
                ),
                Expanded(child: Container()),
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.givtBlue,
                      ),
                      child: Text(locals.giveDifferently),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: TextButton(
                      onPressed: () {},
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
