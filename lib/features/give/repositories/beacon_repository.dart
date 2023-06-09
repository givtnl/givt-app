import 'package:givt_app/core/network/api_service.dart';

class BeaconRepository {
  const BeaconRepository(this._apiService);

  final APIService _apiService;

  Future<bool> sendBeaconBatteryStatus({
    required String guid,
    required String beaconId,
    required int batteryVoltage,
  }) async =>
      _apiService.putBeaconBatteryStatus(
        beaconId: beaconId,
        query: {
          'userId': guid,
        },
        body: {
          'EddyId': batteryVoltage,
          'BatteryVoltage': batteryVoltage,
        },
      );
}
