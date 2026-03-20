import 'package:givt_app/shared/models/organisation_goals.dart';

/// One row on the For You giving page: either a collection (allocation) goal
/// or a general (QR) goal added from the bottom sheet.
sealed class ForYouGoalLineKind {
  const ForYouGoalLineKind();
}

final class ForYouCollectionGoalLine extends ForYouGoalLineKind {
  const ForYouCollectionGoalLine({
    required this.title,
    required this.subtitleIndex,
    this.allocation,
  });

  final String title;
  final int subtitleIndex;
  final OrganisationAllocation? allocation;
}

final class ForYouGeneralGoalLine extends ForYouGoalLineKind {
  const ForYouGeneralGoalLine(this.qr);

  final OrganisationQrCode qr;
}
