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
