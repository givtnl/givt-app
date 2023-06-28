import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location({
    required this.name,
    this.latitude = 0,
    this.longitude = 0,
    this.radius = 0,
    this.beaconId = '',
    this.begin,
    this.end,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['Name'] as String,
      latitude: json['Latitude'] as double,
      longitude: json['Longitude'] as double,
      radius: json['Radius'] as int,
      beaconId: json['BeaconId'] as String,
      begin: json['dtBegin'] == null
          ? null
          : DateTime.parse(json['dtBegin'] as String),
      end: json['dtEnd'] == null
          ? null
          : DateTime.parse(
              json['dtEnd'] as String,
            ),
    );
  }

  final String name;
  final double latitude;
  final double longitude;
  final int radius;
  final String beaconId;
  final DateTime? begin;
  final DateTime? end;

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Latitude': latitude,
      'Longitude': longitude,
      'Radius': radius,
      'BeaconId': beaconId,
      'dtBegin': begin?.toIso8601String(),
      'dtEnd': end?.toIso8601String(),
    };
  }

  Location copyWith({
    String? name,
    double? latitude,
    double? longitude,
    int? radius,
    String? beaconId,
    DateTime? begin,
    DateTime? end,
  }) {
    return Location(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      beaconId: beaconId ?? this.beaconId,
      begin: begin ?? this.begin,
      end: end ?? this.end,
    );
  }

  @override
  List<Object?> get props => [
        name,
        latitude,
        longitude,
        radius,
        beaconId,
        begin,
        end,
      ];
}
