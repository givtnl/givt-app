import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/features/pledges/shared/pledges_partition.dart';

void main() {
  const collectGroup = PledgeCollectGroup(
    id: 'cg-1',
    namespace: 'org.example',
    name: 'Example Church',
  );

  Pledge _pledge({String? endDate}) {
    return Pledge(
      id: '1',
      goalId: 'goal-1',
      pledgeGroupId: 'pg-1',
      type: 'DirectDebit',
      amount: 26,
      frequency: 'Yearly',
      collectGroup: collectGroup,
      pledgeGroupName: 'Campaign',
      goalName: 'Building fund',
      endDate: endDate,
    );
  }

  group('PledgesPartition', () {
    final now = DateTime(2026, 7, 3);

    test('isPast is false when goal end date is today', () {
      expect(
        PledgesPartition.isPast(
          _pledge(endDate: '2026-07-03T00:00:00Z'),
          now: now,
        ),
        isFalse,
      );
    });

    test('isPast is false when goal end date is in the future', () {
      expect(
        PledgesPartition.isPast(
          _pledge(endDate: '2026-12-31T00:00:00Z'),
          now: now,
        ),
        isFalse,
      );
    });

    test('isPast is true when goal end date is before today', () {
      expect(
        PledgesPartition.isPast(
          _pledge(endDate: '2026-07-02T00:00:00Z'),
          now: now,
        ),
        isTrue,
      );
    });

    test('isPast is false when goal end date is missing', () {
      expect(
        PledgesPartition.isPast(_pledge(), now: now),
        isFalse,
      );
    });
  });
}
