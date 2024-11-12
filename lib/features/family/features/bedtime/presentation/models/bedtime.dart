import 'package:equatable/equatable.dart';

class Bedtime extends Equatable {
  Bedtime({
    required this.id,
    required this.bedtimeInUtc,
    required this.winddownMinutes,
  });
  final String id;
  final String bedtimeInUtc;
  final int winddownMinutes;
  @override
  List<Object?> get props => [id, bedtimeInUtc, winddownMinutes];
}

/// Time values sent to BE are in 24-hour format
/// But in Fe in 12-hour format, where:
/// - 7.0 represents 19:00 PM
/// - 9.5 represents 21:30 PM
class BedtimeConfig {
  static const double defaultBedtimeHour = 7;
  static const int defaultBedtimeMinutes = 00;
  static const int defaultWindDownMinutes = 30;
  static const double minBedtimeHour = 6;
  static const double maxBedtimeHour = 9.5;
  static const int minWindDownMinutes = 15;
  static const int maxWindDownMinutes = 60;
  static const int windDownCounterSteps = 5;
  static const int sliderDivisions = 7;
}
