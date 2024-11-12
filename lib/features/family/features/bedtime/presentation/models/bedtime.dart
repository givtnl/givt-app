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
  BedtimeConfig({
    this.defaultBedtimeHour = 7,
    this.defaultBedtimeMinutes = 00,
    this.defaultWindDownMinutes = 30,
    this.minBedtimeHour = 6,
    this.maxBedtimeHour = 9.5,
    this.minWindDownMinutes = 15,
    this.maxWindDownMinutes = 60,
    this.windDownCounterSteps = 5,
    this.sliderDivisions = 7,
  });
  final double defaultBedtimeHour;
  final int defaultBedtimeMinutes;
  final int defaultWindDownMinutes;
  final double minBedtimeHour;
  final double maxBedtimeHour;
  final int minWindDownMinutes;
  final int maxWindDownMinutes;
  final int windDownCounterSteps;
  final int sliderDivisions;
}
