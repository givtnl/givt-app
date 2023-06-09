import 'package:equatable/equatable.dart';

class Beacon extends Equatable {
  const Beacon({
    required this.mediumId,
    required this.batteryStatus,
    required this.rssi,
    required this.macAddress,
  });

  const Beacon.empty()
      : mediumId = '',
        batteryStatus = 0,
        rssi = 0,
        macAddress = '';

  factory Beacon.fromJson(Map<String, dynamic> json) => Beacon(
        mediumId: json['MediumId'] as String,
        batteryStatus: json['BatteryStatus'] as int,
        rssi: json['RSSI'] as int,
        macAddress: json['MacAddress'] as String,
      );

  final String mediumId;
  final int batteryStatus;
  final int rssi;
  final String macAddress;

  Beacon copyWith({
    String? mediumId,
    int? batteryStatus,
    int? rssi,
    String? macAddress,
  }) {
    return Beacon(
      mediumId: mediumId ?? this.mediumId,
      batteryStatus: batteryStatus ?? this.batteryStatus,
      rssi: rssi ?? this.rssi,
      macAddress: macAddress ?? this.macAddress,
    );
  }

  @override
  List<Object?> get props => [
        mediumId,
        batteryStatus,
        rssi,
        macAddress,
      ];
}
