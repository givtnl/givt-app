import 'package:collection/collection.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';

class LeagueEntryUIModel {
  const LeagueEntryUIModel({
    required this.rank,
    this.name,
    this.xp,
    this.imageUrl,
  });

  factory LeagueEntryUIModel.fromEntryAndProfile(
      int rank, LeagueItem item, Profile profile) {
    return LeagueEntryUIModel(
      rank: rank,
      name: profile.firstName,
      xp: item.experiencePoints,
      imageUrl: profile.pictureURL,
    );
  }

  // Match profiles to xp entries
  // Calculate rank
  // Sort on xp, then alphabetically
  static List<LeagueEntryUIModel> listFromEntriesAndProfiles(
      List<LeagueItem> league, List<Profile> profiles) {
    final listOfUniqueAndSortedExperiencePoints = league
        .map((e) => e.experiencePoints)
        .toSet()
        .toList()
      ..sort((a, b) => b!.compareTo(a!));
    final list = league.mapIndexed((int index, entry) {
      final profile = profiles.firstWhere(
        (p) => p.id == entry.guid,
        orElse: Profile.empty,
      );
      final rank = listOfUniqueAndSortedExperiencePoints
              .where(
                (xp) => xp! > entry.experiencePoints!,
              )
              .length +
          1;
      return LeagueEntryUIModel.fromEntryAndProfile(rank, entry, profile);
    }).toList()
      ..removeWhere(
        (e) => e.name.isNullOrEmpty(),
      ) //we're waiting on a profiles update
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''))
      ..sort((a, b) => a.rank.compareTo(b.rank));
    return list;
  }

  final int rank;
  final String? name;
  final int? xp;
  final String? imageUrl;
}
