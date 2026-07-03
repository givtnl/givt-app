import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/detail/pledge_detail_history_builder.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';

void main() {
  group('PledgeTransaction', () {
    test('fromJson parses transaction fields', () {
      final transaction = PledgeTransaction.fromJson({
        'id': 42,
        'amount': 150.0,
        'donationDate': '2026-06-15T11:30:00Z',
        'status': 'Processed',
      });

      expect(transaction.id, 42);
      expect(transaction.amount, 150);
      expect(transaction.isProcessed, isTrue);
      expect(transaction.donationDateTime, isNotNull);
    });
  });

  group('PledgeGroup detail aggregates', () {
    final group = PledgeGroup.fromJson({
      'pledgeGroupId': 'group-1',
      'pledgeGroupName': 'Actie Kerkbalans',
      'collectGroupId': 'church-1',
      'collectGroupNamespace': 'church',
      'collectGroupName': 'Church',
      'startDate': '2026-01-01T00:00:00Z',
      'endDate': '2026-09-22T00:00:00Z',
      'goals': [
        {
          'id': 'goal-1',
          'goalId': 'g1',
          'goalName': 'Church fund',
          'amount': 150,
          'frequency': 'Monthly',
          'type': 'Online',
          'goalAmount': 1800,
          'nextExecutionDate': '2026-07-15T00:00:00Z',
          'transactions': [
            {
              'id': 1,
              'amount': 150,
              'donationDate': '2026-06-15T11:30:00Z',
              'status': 'Processed',
            },
            {
              'id': 2,
              'amount': 150,
              'donationDate': '2026-05-15T11:30:00Z',
              'status': 'Processed',
            },
          ],
        },
        {
          'id': 'goal-2',
          'goalId': 'g2',
          'goalName': 'Mission',
          'amount': 50,
          'frequency': 'Monthly',
          'type': 'Online',
          'goalAmount': 600,
          'nextExecutionDate': '2026-07-15T00:00:00Z',
          'transactions': [
            {
              'id': 3,
              'amount': 50,
              'donationDate': '2026-06-15T11:30:00Z',
              'status': 'Processed',
            },
          ],
        },
      ],
    });

    test('givenSoFar sums processed transactions across goals', () {
      expect(group.givenSoFar, 350);
      expect(group.totalPledged, 2400);
      expect(group.segmentBarTotal, 2400);
    });

    test('segmentBarTotal falls back to givenSoFar without goal targets', () {
      final groupWithoutTargets = PledgeGroup.fromJson({
        'pledgeGroupId': 'group-1',
        'pledgeGroupName': 'Actie Kerkbalans',
        'collectGroupId': 'church-1',
        'collectGroupNamespace': 'church',
        'collectGroupName': 'Church',
        'goals': [
          {
            'id': 'goal-1',
            'goalId': 'g1',
            'goalName': 'Church fund',
            'amount': 26,
            'frequency': 'Monthly',
            'type': 'Online',
            'paidAmount': 10,
          },
          {
            'id': 'goal-2',
            'goalId': 'g2',
            'goalName': 'Mission',
            'amount': 15,
            'frequency': 'Monthly',
            'type': 'Online',
          },
        ],
      });

      expect(groupWithoutTargets.totalPledged, isNull);
      expect(groupWithoutTargets.givenSoFar, 10);
      expect(groupWithoutTargets.segmentBarTotal, 10);
    });

    test('totalPledged uses amount for all-at-once goals without goalAmount', () {
      final allAtOnceGroup = PledgeGroup.fromJson({
        'pledgeGroupId': 'group-1',
        'pledgeGroupName': 'Actie Kerkbalans 2026',
        'collectGroupId': 'church-1',
        'collectGroupNamespace': 'church',
        'collectGroupName': 'Church',
        'goals': [
          {
            'id': 'goal-1',
            'goalId': 'g1',
            'goalName': 'Church balance',
            'amount': 26,
            'frequency': 'Yearly',
            'type': 'Online',
          },
          {
            'id': 'goal-2',
            'goalId': 'g2',
            'goalName': 'Mission',
            'amount': 15,
            'frequency': 'Once',
            'type': 'Online',
          },
        ],
      });

      expect(allAtOnceGroup.totalPledged, 41);
    });
  });

  group('PledgeDetailHistoryBuilder', () {
    final group = PledgeGroup.fromJson({
      'pledgeGroupId': 'group-1',
      'pledgeGroupName': 'Actie Kerkbalans',
      'collectGroupId': 'church-1',
      'collectGroupNamespace': 'church',
      'collectGroupName': 'Church',
      'goals': [
        {
          'id': 'goal-1',
          'goalId': 'g1',
          'goalName': 'Church fund',
          'amount': 150,
          'frequency': 'Monthly',
          'type': 'Online',
          'nextExecutionDate': '2026-07-15T00:00:00Z',
          'transactions': [
            {
              'id': 1,
              'amount': 150,
              'donationDate': '2026-06-15T11:30:00Z',
              'status': 'Processed',
            },
          ],
        },
        {
          'id': 'goal-2',
          'goalId': 'g2',
          'goalName': 'Mission',
          'amount': 50,
          'frequency': 'Monthly',
          'type': 'Online',
          'nextExecutionDate': '2026-07-15T00:00:00Z',
          'transactions': [],
        },
      ],
    });

    test('build includes upcoming and past history items', () {
      final history = PledgeDetailHistoryBuilder.build(
        group: group,
        now: DateTime(2026, 7, 1),
      );

      expect(history, hasLength(2));
      expect(history.first.isUpcoming, isTrue);
      expect(history.first.goalLines, hasLength(2));
      expect(history.last.isUpcoming, isFalse);
      expect(history.last.goalLines.single.amount, 150);
    });
  });
}
