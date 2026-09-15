import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/shared/models/collect_group.dart';

/// Fills blank Givt organisation names from the local collect-group list.
///
/// The donation-history BFF resolves names from collect groups via medium
/// lookup. When that fails, [organisationName] is empty and the overview
/// only shows the collection subtitle (e.g. "Collecte 1").
abstract final class DonationOrganisationNameResolver {
  const DonationOrganisationNameResolver._();

  static List<DonationItem> fillMissingNames(
    List<DonationItem> donations,
    List<CollectGroup> collectGroups,
  ) {
    if (donations.isEmpty || collectGroups.isEmpty) {
      return donations;
    }

    return [
      for (final donation in donations)
        _withResolvedName(donation, collectGroups),
    ];
  }

  static DonationItem _withResolvedName(
    DonationItem donation,
    List<CollectGroup> collectGroups,
  ) {
    final existing = donation.organisationName.trim();
    if (existing.isNotEmpty) {
      return existing == donation.organisationName
          ? donation
          : donation.copyWith(organisationName: existing);
    }

    if (donation.isExternal) {
      return donation;
    }

    final resolved = nameFromMediumId(donation.mediumId, collectGroups);
    if (resolved == null) {
      return donation;
    }

    return donation.copyWith(organisationName: resolved);
  }

  static String? nameFromMediumId(
    String mediumId,
    List<CollectGroup> collectGroups,
  ) {
    final namespace = namespaceFromMediumId(mediumId);
    if (namespace.isEmpty) {
      return null;
    }

    final exact = collectGroups
        .where((group) => group.nameSpace == namespace)
        .firstOrNull;
    if (exact != null) {
      final name = exact.orgName.trim();
      if (name.isNotEmpty) {
        return name;
      }
    }

    final contained = collectGroups
        .where(
          (group) =>
              group.nameSpace.isNotEmpty && mediumId.contains(group.nameSpace),
        )
        .firstOrNull;
    final containedName = contained?.orgName.trim() ?? '';
    return containedName.isEmpty ? null : containedName;
  }

  static String namespaceFromMediumId(String mediumId) {
    final trimmed = mediumId.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    final separator = trimmed.indexOf('.');
    return separator == -1 ? trimmed : trimmed.substring(0, separator);
  }
}
