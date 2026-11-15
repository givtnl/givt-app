import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_platform_interface/flutter_blue_plus_platform_interface.dart';

/// Returns whether a platform stop scan was invoked.
///
/// FBP 1.36.8 [FlutterBluePlus.stopScan] only calls native stop when
/// [FlutterBluePlus.isScanningNow] is true; otherwise it logs and returns.
Future<bool> stopForYouBleScanOnPlatform() async {
  if (FlutterBluePlus.isScanningNow) {
    await FlutterBluePlus.stopScan();
    return true;
  }
  if (!Platform.isAndroid) {
    return false;
  }
  await FlutterBluePlusPlatform.instance.stopScan(BmStopScanRequest());
  return true;
}