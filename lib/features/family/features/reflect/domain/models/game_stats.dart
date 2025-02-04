class GameStats {
  GameStats({
    required this.totalActions,
    required this.totalSecondsPlayed,
    this.currentDailyXP,
  });

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      totalActions: json['totalActions'] as int,
      totalSecondsPlayed: json['totalSecondsPlayed'] as int,
      currentDailyXP: json['currentDailyXP'] as int?,
    );
  }

  int totalActions;
  int totalSecondsPlayed;
  int? currentDailyXP;
}
