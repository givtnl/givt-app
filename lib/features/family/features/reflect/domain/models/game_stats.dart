class GameStats {
  GameStats({
    required this.totalActions,
    required this.totalSecondsPlayed,
    required this.gratitudeGoal,
    required this.gratitudeGoalCurrent,
  });

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      totalActions: json['totalActions'] as int,
      totalSecondsPlayed: json['totalSecondsPlayed'] as int,
      gratitudeGoal: json['gratitudeGoal'] as int,
      gratitudeGoalCurrent: json['gratitudeGoalCurrent'] as int,
    );
  }

  int totalActions;
  int totalSecondsPlayed;
  int gratitudeGoal;
  int gratitudeGoalCurrent;
}
