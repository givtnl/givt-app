class Bedtime {
  Bedtime({
    required this.id,
    required this.bedtimeInUtc,
    required this.winddownMinutes,
  });
  final String id;
  final String bedtimeInUtc;
  final int winddownMinutes;
}

class BedtimeConfig {
  BedtimeConfig({
    this.defaultBedtimeHour = 7,
    this.defaultBedtimeMinutes = 00,
    this.defaultwidndownMinutes = 30,
    this.minBedtimeHour = 6,
    this.maxBedtimeHour = 9.5,
    this.minWindDownMinutes = 15,
    this.maxWindDownMinutes = 60,
  });
  final double defaultBedtimeHour;
  final int defaultBedtimeMinutes;
  final int defaultwidndownMinutes;
  final double minBedtimeHour;
  final double maxBedtimeHour;
  final int minWindDownMinutes;
  final int maxWindDownMinutes;
  final int windDownCounterSteps = 5;

  int get sliderDivisionsCount => (maxBedtimeHour - minBedtimeHour).toInt() * 2;
}
