import 'package:collection/collection.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/shared/design/components/content/models/custom_avatar_uimodel.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';

class LeagueEntryUIModel {
  const LeagueEntryUIModel({
    required this.rank,
    this.name,
    this.xp,
    this.avatar,
    this.customAvatarUIModel,
  });

  factory LeagueEntryUIModel.fromEntryAndProfile(
      int rank, LeagueItem item, Profile profile) {
    return LeagueEntryUIModel(
      rank: rank,
      name: profile.firstName,
      xp: item.experiencePoints,
      avatar: profile.avatar,
      customAvatarUIModel: profile.customAvatar?.toUIModel(),
    );
  }

  // Match profiles to xp entries
  // Calculate rank
  // Sort on xp, then alphabetically
  static List<LeagueEntryUIModel> listFromEntriesAndProfiles(
    List<LeagueItem> league,
    List<Profile> profiles,
  ) {
    // Get unique and sorted list of experience points
    final listOfUniqueAndSortedExperiencePoints = league
        .map((e) => e.experiencePoints)
        .toSet()
        .toList()
      ..sort((a, b) => b!.compareTo(a!));

    // Map league items to league entry UI models
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
      // Remove entries without a name
      ..removeWhere(
        (e) => e.name.isNullOrEmpty(),
      ) // we're waiting on a profiles update
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''))
      ..sort((a, b) => a.rank.compareTo(b.rank));

    // Add profiles without league entries
    final rank = list.length + 1;
    for (final profile in profiles) {
      if (!list.any((e) => e.name == profile.firstName)) {
        list.add(
          LeagueEntryUIModel(
            rank: rank,
            name: profile.firstName,
            avatar: profile.avatar,
            xp: 0,
          ),
        );
      }
    }
    return list;
  }

  final int rank;
  final String? name;
  final int? xp;
  final String? avatar;
  final CustomAvatarUIModel? customAvatarUIModel;
}
