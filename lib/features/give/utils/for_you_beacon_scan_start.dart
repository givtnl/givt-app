import 'package:givt_app/features/give/utils/for_you_beacon_scan_errors.dart';

/// Runs [startScan], and on SCAN_FAILED_ALREADY_STARTED stops on the platform,
/// optionally settles, then retries [startScan] once.
Future<void> startForYouBeaconScanWithAlreadyStartedRetry({
  required Future<void> Function() startScan,
  required Future<bool> Function() stopOnPlatform,
  required bool androidSettleAfterPlatformStop,
  Future<void> Function(Duration delay)? delay,
}) async {
  final wait = delay ?? Future<void>.delayed;
  try {
    await startScan();
    return;
  } on Object catch (e) {
    if (!isBleScanAlreadyStartedError(e)) {
      rethrow;
    }
  }
  final stopped = await stopOnPlatform();
  if (androidSettleAfterPlatformStop && stopped) {
    await wait(const Duration(milliseconds: 150));
  }
  await startScan();
}
