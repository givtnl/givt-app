import 'package:givt_app/features/give/models/for_you_goal_line.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:intl/intl.dart';

/// Builds donation payloads for the For You flow (collection rows share the
/// collect group namespace; general goals use each QR medium id).
List<GivtTransaction> buildForYouDonationTransactions({
  required String userGuid,
  required String collectGroupNamespace,
  required List<ForYouGoalLineKind> lines,
  required List<double> amounts,
  String? collectionGoalsMediumIdOverride,
}) {
  assert(
    lines.length == amounts.length,
    'lines and amounts must align',
  );
  final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(
    DateTime.now().toUtc(),
  );
  final out = <GivtTransaction>[];
  var collectionSlotIndex = 0;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final amount = amounts[i];
    switch (line) {
      case ForYouCollectionGoalLine(:final allocation):
        final collectId = allocation != null && allocation.collectId.isNotEmpty
            ? allocation.collectId
            : '${collectionSlotIndex + 1}';
        collectionSlotIndex++;
        if (amount == 0.0) {
          continue;
        }
        out.add(
          GivtTransaction(
            guid: userGuid,
            amount: amount,
            beaconId: (collectionGoalsMediumIdOverride ?? '').trim().isNotEmpty
                ? collectionGoalsMediumIdOverride!.trim()
                : collectGroupNamespace,
            timestamp: formattedDate,
            collectId: collectId,
          ),
        );
      case ForYouGeneralGoalLine(:final qr):
        if (amount == 0.0) {
          continue;
        }
        out.add(
          GivtTransaction(
            guid: userGuid,
            amount: amount,
            beaconId: qr.mediumId,
            timestamp: formattedDate,
            collectId: '1',
          ),
        );
    }
  }

  return out;
}
