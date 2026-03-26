import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/shared/models/collect_group.dart';

List<CollectGroup> sortForYouFavoriteCards(List<CollectGroup> organisations) {
  final indexedOrganisations = organisations.asMap().entries.toList()
    ..sort((a, b) {
      final priorityComparison = _favoriteCardTypePriority(
        a.value.type,
      ).compareTo(_favoriteCardTypePriority(b.value.type));
      if (priorityComparison != 0) {
        return priorityComparison;
      }

      // Keep the original order within each type group.
      return a.key.compareTo(b.key);
    });

  return indexedOrganisations.map((entry) => entry.value).toList();
}

int _favoriteCardTypePriority(CollectGroupType type) {
  return switch (type) {
    CollectGroupType.church => 0,
    CollectGroupType.charities => 1,
    _ => 2,
  };
}
