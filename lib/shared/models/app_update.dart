import 'package:equatable/equatable.dart';

class AppUpdate extends Equatable {
  const AppUpdate({
    required this.buildNumber,
    required this.critical,
    required this.deviceOS,
  });

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
        buildNumber: json['buildNumber'] as int,
        critical: json['critical'] as bool,
        deviceOS: json['deviceOS'] as int,
      );

  final int buildNumber;
  final bool critical;
  final int deviceOS;

  Map<String, dynamic> toJson() => {
        'buildNumber': buildNumber,
        'critical': critical,
        'deviceOS': deviceOS,
      };

  AppUpdate copyWith({
    int? buildNumber,
    bool? critical,
    int? deviceOS,
  }) {
    return AppUpdate(
      buildNumber: buildNumber ?? this.buildNumber,
      critical: critical ?? this.critical,
      deviceOS: deviceOS ?? this.deviceOS,
    );
  }

  @override
  List<Object?> get props => [
        buildNumber,
        critical,
        deviceOS,
      ];
}
