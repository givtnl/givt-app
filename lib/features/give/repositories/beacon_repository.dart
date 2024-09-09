import 'package:givt_app/core/network/api_service.dart';

mixin BeaconRepository {
  Future<bool> sendBeaconBatteryStatus({
    required String guid,
    required String beaconId,
    required int batteryVoltage,
  });
}

class BeaconRepositoryImpl with BeaconRepository {
  const BeaconRepositoryImpl(this._apiService);

  final APIService _apiService;

  @override
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
