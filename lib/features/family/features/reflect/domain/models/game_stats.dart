class GameStats {
  GameStats({required this.totalActions, required this.totalSecondsPlayed});

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      totalActions: json['totalActions'] as int,
      totalSecondsPlayed: json['totalSecondsPlayed'] as int,
    );
  }

  int totalActions;
  int totalSecondsPlayed;
}
