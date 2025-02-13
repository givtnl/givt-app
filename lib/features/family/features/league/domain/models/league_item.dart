class LeagueItem {
  LeagueItem(this.guid, this.experiencePoints);

  factory LeagueItem.fromMap(Map<String, dynamic> item) {
    return LeagueItem(
      item['guid'] as String?,
      item['experiencePoints'] as int?,
    );
  }

  final String? guid;
  final int? experiencePoints;

  bool isValid() {
    return guid != null && experiencePoints != null;
  }
}
