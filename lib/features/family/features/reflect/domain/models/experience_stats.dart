class ExperienceStats {
  ExperienceStats({
    required this.xpEarnedForTime,
    required this.xpEarnedForDeeds,
    required this.variableReward,
    required this.variableRewardImage,
  });

  factory ExperienceStats.fromJson(Map<String, dynamic> json) {
    return ExperienceStats(
      xpEarnedForTime: json['experiencePointsTime'] as int?,
      xpEarnedForDeeds: json['experiencePointsDeeds'] as int?,
      variableReward: json['variableReward'] as String?,
      variableRewardImage: json['variableRewardImage'] as String?,
    );
  }

  int? xpEarnedForTime;
  int? xpEarnedForDeeds;
  String? variableReward;
  String? variableRewardImage;
}
