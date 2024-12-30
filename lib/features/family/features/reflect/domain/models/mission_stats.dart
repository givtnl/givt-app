class MissionStats {
  MissionStats({required this.missionsToBeCompleted});

  factory MissionStats.fromJson(Map<String, dynamic> json) {
    return MissionStats(
      missionsToBeCompleted: json['missionsToBeCompleted'] as int,
    );
  }

  int missionsToBeCompleted;
}
