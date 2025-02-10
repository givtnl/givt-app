class ExperienceStats {
  ExperienceStats({
    required this.xpEarnedForTime,
    required this.xpEarnedForDeeds,
  });

  factory ExperienceStats.fromJson(Map<String, dynamic> json) {
    return ExperienceStats(
      xpEarnedForTime: json['experiencePointsTime'] as int?,
      xpEarnedForDeeds: json['experiencePointsDeeds'] as int?,
    );
  }

  int? xpEarnedForTime;
  int? xpEarnedForDeeds;
}
