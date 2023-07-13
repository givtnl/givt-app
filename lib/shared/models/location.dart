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

  const Location.empty()
      : name = '',
        latitude = 0,
        longitude = 0,
        radius = 0,
        beaconId = '',
        begin = null,
        end = null;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['N'] != null ? json['N'] as String : '',
      latitude: json['LA'] as double,
      longitude: json['LO'] as double,
      radius: json['R'] as int,
      beaconId: json['I'] as String,
      begin: json['DB'] == null ? null : DateTime.parse(json['DB'] as String),
      end: json['DE'] == null
          ? null
          : DateTime.parse(
              json['DE'] as String,
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
      'N': name,
      'LA': latitude,
      'LO': longitude,
      'R': radius,
      'I': beaconId,
      'DB': begin?.toIso8601String(),
      'DE': end?.toIso8601String(),
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
