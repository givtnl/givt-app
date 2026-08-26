import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/detail/pledge_detail_history_builder.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';

void main() {
  group('PledgeTransaction', () {
    test('fromJson parses scheduled transaction fields', () {
      final transaction = PledgeTransaction.fromJson({
        'id': 'tx-42',
        'amount': 150.0,
        'executionDate': '2026-06-15T11:30:00Z',
        'state': 'Processed',
      });

      expect(transaction.id, 'tx-42');
      expect(transaction.amount, 150);
      expect(transaction.isProcessed, isTrue);
      expect(transaction.executionDateTime, isNotNull);
    });

    test('fromJson parses numeric PledgeTransactionState values', () {
      final entered = PledgeTransaction.fromJson({
        'id': 'tx-1',
        'amount': 10,
        'executionDate': '2026-06-15T00:00:00Z',
        'state': 1,
      });
      final processed = PledgeTransaction.fromJson({
        'id': 'tx-2',
        'amount': 10,
        'executionDate': '2026-06-15T00:00:00Z',
        'state': 2,
      });

      expect(entered.isEntered, isTrue);
      expect(processed.isProcessed, isTrue);
    });

    test('parseState maps backend enum values', () {
      expect(PledgeTransaction.parseState('Entered'), 'Entered');
      expect(PledgeTransaction.parseState('Processed'), 'Processed');
      expect(PledgeTransaction.parseState(1), 'Entered');
      expect(PledgeTransaction.parseState(2), 'Processed');
      expect(PledgeTransaction.parseState(3), 'Canceled');
    });
  });

  group('PledgeDonation', () {
    test('fromJson parses wallet donation fields', () {
      final donation = PledgeDonation.fromJson({
        'id': 42,
        'amount': 150.0,
        'donationDate': '2026-06-15T11:30:00Z',
        'status': 'Processed',
      });

      expect(donation.id, 42);
      expect(donation.isProcessed, isTrue);
      expect(donation.donationDateTime, isNotNull);
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
          'totalAmount': 1800,
          'type': 'Online',
          'transactions': [
            {
              'id': 'tx-1',
              'amount': 150,
              'executionDate': '2026-06-15T11:30:00Z',
              'state': 'Processed',
            },
            {
              'id': 'tx-2',
              'amount': 150,
              'executionDate': '2026-05-15T11:30:00Z',
              'state': 'Processed',
            },
          ],
          'donations': [
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
          'totalAmount': 600,
          'type': 'Online',
          'transactions': [
            {
              'id': 'tx-3',
              'amount': 50,
              'executionDate': '2026-06-15T11:30:00Z',
              'state': 'Processed',
            },
          ],
          'donations': [
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

    test('givenSoFar sums processed donations across goals', () {
      expect(group.givenSoFar, 350);
      expect(group.totalPledged, 2400);
      expect(group.segmentBarTotal, 2400);
    });

    test('transaction counts sum processed and total across goals', () {
      expect(group.totalTransactionCount, 3);
      expect(group.completedTransactionCount, 3);
    });

    test('transaction counts treat Entered as not completed', () {
      final singleGoalGroup = PledgeGroup.fromJson({
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
            'totalAmount': 450,
            'type': 'Online',
            'transactions': [
              {
                'id': 'tx-1',
                'amount': 150,
                'executionDate': '2026-04-15T00:00:00Z',
                'state': 'Processed',
              },
              {
                'id': 'tx-2',
                'amount': 150,
                'executionDate': '2026-05-15T00:00:00Z',
                'state': 'Processed',
              },
              {
                'id': 'tx-3',
                'amount': 150,
                'executionDate': '2026-06-15T00:00:00Z',
                'state': 'Entered',
              },
            ],
          },
        ],
      });

      expect(singleGoalGroup.totalTransactionCount, 3);
      expect(singleGoalGroup.completedTransactionCount, 2);
    });

    test('transaction counts are zero when no transactions exist', () {
      final emptyGroup = PledgeGroup.fromJson({
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
            'totalAmount': 0,
            'type': 'Online',
            'transactions': const [],
          },
        ],
      });

      expect(emptyGroup.totalTransactionCount, 0);
      expect(emptyGroup.completedTransactionCount, 0);
    });

    test('transaction counts ignore wallet donations', () {
      final groupWithDonations = PledgeGroup.fromJson({
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
            'totalAmount': 450,
            'type': 'Online',
            'transactions': [
              {
                'id': 'tx-1',
                'amount': 150,
                'executionDate': '2026-04-15T00:00:00Z',
                'state': 'Processed',
              },
              {
                'id': 'tx-2',
                'amount': 150,
                'executionDate': '2026-05-15T00:00:00Z',
                'state': 'Entered',
              },
              {
                'id': 'tx-3',
                'amount': 150,
                'executionDate': '2026-06-15T00:00:00Z',
                'state': 'Entered',
              },
            ],
            'donations': [
              {
                'id': 1,
                'amount': 150,
                'donationDate': '2026-04-15T00:00:00Z',
                'status': 'Processed',
              },
              {
                'id': 2,
                'amount': 150,
                'donationDate': '2026-05-15T00:00:00Z',
                'status': 'Processed',
              },
              {
                'id': 3,
                'amount': 150,
                'donationDate': '2026-06-15T00:00:00Z',
                'status': 'Processed',
              },
              {
                'id': 4,
                'amount': 150,
                'donationDate': '2026-07-15T00:00:00Z',
                'status': 'Processed',
              },
            ],
          },
        ],
      });

      expect(groupWithDonations.totalTransactionCount, 3);
      expect(groupWithDonations.completedTransactionCount, 1);
      expect(groupWithDonations.givenSoFar, 600);
    });

    test('segmentBarTotal falls back to givenSoFar without commitment totals', () {
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
            'totalAmount': 0,
            'type': 'Online',
            'transactions': [
              {
                'id': 'tx-1',
                'amount': 10,
                'executionDate': '2026-06-15T11:30:00Z',
                'state': 'Processed',
              },
            ],
          },
          {
            'id': 'goal-2',
            'goalId': 'g2',
            'goalName': 'Mission',
            'totalAmount': 0,
            'type': 'Online',
            'transactions': const [],
          },
        ],
      });

      expect(groupWithoutTargets.totalPledged, isNull);
      expect(groupWithoutTargets.givenSoFar, 10);
      expect(groupWithoutTargets.segmentBarTotal, 10);
    });

    test('totalPledged uses totalAmount for all goals', () {
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
            'totalAmount': 26,
            'type': 'Online',
            'transactions': [
              {
                'id': 'tx-1',
                'amount': 26,
                'executionDate': '2026-12-31T00:00:00Z',
                'state': 'Entered',
              },
            ],
          },
          {
            'id': 'goal-2',
            'goalId': 'g2',
            'goalName': 'Mission',
            'totalAmount': 15,
            'type': 'Online',
            'transactions': [
              {
                'id': 'tx-2',
                'amount': 15,
                'executionDate': '2026-12-31T00:00:00Z',
                'state': 'Entered',
              },
            ],
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
          'totalAmount': 300,
          'type': 'Online',
          'transactions': [
            {
              'id': 'tx-1',
              'amount': 150,
              'executionDate': '2026-07-15T00:00:00Z',
              'state': 'Entered',
            },
            {
              'id': 'tx-2',
              'amount': 150,
              'executionDate': '2026-06-15T11:30:00Z',
              'state': 'Processed',
            },
          ],
          'donations': [
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
          'totalAmount': 50,
          'type': 'Online',
          'transactions': [
            {
              'id': 'tx-3',
              'amount': 50,
              'executionDate': '2026-07-15T00:00:00Z',
              'state': 'Entered',
            },
          ],
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
