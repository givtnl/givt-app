import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class BTScanPage extends StatefulWidget {
  const BTScanPage({super.key});

  @override
  State<BTScanPage> createState() => _BTScanPageState();
}

class _BTScanPageState extends State<BTScanPage> {
  late FlutterBluePlus flutterBlue;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    flutterBlue = FlutterBluePlus.instance;
    flutterBlue
      ..startScan(timeout: const Duration(seconds: 30)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
      )
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
              userGUID: context.read<AuthCubit>().state.user.guid,
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
