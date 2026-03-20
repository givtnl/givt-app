import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/models/for_you_goal_line.dart';
import 'package:givt_app/features/give/utils/for_you_donation_transactions.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';

void main() {
  group('buildForYouDonationTransactions', () {
    const ns = 'collect.group.ns';

    test('skips zero amounts', () {
      final lines = <ForYouGoalLineKind>[
        const ForYouCollectionGoalLine(
          title: 'A',
          subtitleIndex: 1,
          allocation: OrganisationAllocation(
            collectId: '10',
            allocationName: 'A',
            collectGroupId: 'g',
          ),
        ),
      ];
      final txs = buildForYouDonationTransactions(
        userGuid: 'u1',
        collectGroupNamespace: ns,
        lines: lines,
        amounts: [0],
      );
      expect(txs, isEmpty);
    });

    test('collection goal uses namespace and allocation collectId', () {
      final lines = <ForYouGoalLineKind>[
        const ForYouCollectionGoalLine(
          title: 'A',
          subtitleIndex: 1,
          allocation: OrganisationAllocation(
            collectId: '42',
            allocationName: 'A',
            collectGroupId: 'g',
          ),
        ),
      ];
      final txs = buildForYouDonationTransactions(
        userGuid: 'u1',
        collectGroupNamespace: ns,
        lines: lines,
        amounts: [12.5],
      );
      expect(txs, hasLength(1));
      expect(txs.single.amount, 12.5);
      expect(txs.single.guid, 'u1');
      expect(txs.single.beaconId, ns);
      expect(txs.single.collectId, '42');
    });

    test('fallback collection slot uses 1-based slot when allocation null', () {
      final lines = <ForYouGoalLineKind>[
        const ForYouCollectionGoalLine(
          title: 'A',
          subtitleIndex: 1,
          allocation: null,
        ),
        const ForYouCollectionGoalLine(
          title: 'B',
          subtitleIndex: 2,
          allocation: null,
        ),
      ];
      final txs = buildForYouDonationTransactions(
        userGuid: 'u1',
        collectGroupNamespace: ns,
        lines: lines,
        amounts: [1, 2],
      );
      expect(txs, hasLength(2));
      expect(txs[0].collectId, '1');
      expect(txs[1].collectId, '2');
    });

    test('general goal uses QR mediumId and collectId 1', () {
      final lines = <ForYouGoalLineKind>[
        ForYouGeneralGoalLine(
          OrganisationQrCode(
            mediumId: 'qr.medium',
            allocationName: 'Mission',
            collectGroupId: 'g',
          ),
        ),
      ];
      final txs = buildForYouDonationTransactions(
        userGuid: 'u1',
        collectGroupNamespace: ns,
        lines: lines,
        amounts: [5],
      );
      expect(txs, hasLength(1));
      expect(txs.single.beaconId, 'qr.medium');
      expect(txs.single.collectId, '1');
    });
  });
}
