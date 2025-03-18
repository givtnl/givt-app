class ExperienceStats {
  ExperienceStats({
    required this.xpEarnedForTime,
    required this.xpEarnedForDeeds,
    required this.variableReward,
  });

  factory ExperienceStats.fromJson(Map<String, dynamic> json) {
    return ExperienceStats(
      xpEarnedForTime: json['experiencePointsTime'] as int?,
      xpEarnedForDeeds: json['experiencePointsDeeds'] as int?,
      variableReward: json['variableReward'] as String?,
    );
  }

  int? xpEarnedForTime;
  int? xpEarnedForDeeds;
  String? variableReward;
}
