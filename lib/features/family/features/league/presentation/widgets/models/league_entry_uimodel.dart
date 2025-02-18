class LeagueEntryUIModel {
  LeagueEntryUIModel({
    required this.rank,
    this.name,
    this.xp,
    this.imageUrl,
  });

  final int rank;
  final String? name;
  final int? xp;
  final String? imageUrl;
}
