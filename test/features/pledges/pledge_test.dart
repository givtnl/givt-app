import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';

void main() {
  group('PledgeGroup', () {
    const sampleGroupJson = {
      'pledgeGroupId': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      'pledgeGroupName': '2026 Pledge Campaign',
      'collectGroupId': 'f9e8d7c6-b5a4-3210-fedc-ba0987654321',
      'collectGroupNamespace': 'stmarys',
      'collectGroupName': "St. Mary's Church",
      'startDate': '2026-01-01T00:00:00Z',
      'endDate': '2026-12-31T00:00:00Z',
      'goals': [
        {
          'id': '11111111-1111-1111-1111-111111111111',
          'goalId': '22222222-2222-2222-2222-222222222222',
          'goalName': 'Building Fund',
          'totalAmount': 306.00,
          'type': 'Online',
          'transactions': [
            {
              'id': 'tx-1',
              'amount': 25.50,
              'executionDate': '2026-08-01T00:00:00Z',
              'state': 'Entered',
            },
            {
              'id': 'tx-2',
              'amount': 25.50,
              'executionDate': '2026-09-01T00:00:00Z',
              'state': 'Entered',
            },
          ],
        },
        {
          'id': '33333333-3333-3333-3333-333333333333',
          'goalId': '44444444-4444-4444-4444-444444444444',
          'goalName': 'Youth Ministry',
          'totalAmount': 40.00,
          'type': 'DirectDebit',
          'transactions': [
            {
              'id': 'tx-3',
              'amount': 10.00,
              'executionDate': '2026-08-01T00:00:00Z',
              'state': 'Entered',
            },
          ],
        },
      ],
    };

    test('fromJson parses pledge group with nested goals', () {
      final group = PledgeGroup.fromJson(sampleGroupJson);

      expect(group.pledgeGroupId, 'a1b2c3d4-e5f6-7890-abcd-ef1234567890');
      expect(group.pledgeGroupName, '2026 Pledge Campaign');
      expect(group.collectGroup.id, 'f9e8d7c6-b5a4-3210-fedc-ba0987654321');
      expect(group.collectGroup.namespace, 'stmarys');
      expect(group.collectGroup.name, "St. Mary's Church");
      expect(group.startDate, '2026-01-01T00:00:00Z');
      expect(group.endDate, '2026-12-31T00:00:00Z');
      expect(group.goals, hasLength(2));
      expect(group.goals.first.goalName, 'Building Fund');
      expect(group.goals.first.totalAmount, 306);
      expect(group.goals.last.type, 'DirectDebit');
    });

    test('upcomingInstallmentAmount uses earliest future entered transaction', () {
      final goal = PledgeGoal.fromJson({
        'id': 'goal-1',
        'goalId': 'g1',
        'goalName': 'Building Fund',
        'totalAmount': 306,
        'type': 'Online',
        'transactions': [
          {
            'id': 'tx-2',
            'amount': 25.50,
            'executionDate': '2026-09-01T00:00:00Z',
            'state': 'Entered',
          },
          {
            'id': 'tx-1',
            'amount': 25.50,
            'executionDate': '2026-08-01T00:00:00Z',
            'state': 'Entered',
          },
        ],
      });

      expect(goal.upcomingInstallmentAmount, 25.5);
      expect(goal.installmentAmount, 25.5);
      expect(goal.upcomingInstallmentAmount, isNot(goal.totalAmount));
    });

    test('toPledges flattens goals with campaign metadata', () {
      final pledges = PledgeGroup.fromJson(sampleGroupJson).toPledges();

      expect(pledges, hasLength(2));
      expect(pledges.first.id, '11111111-1111-1111-1111-111111111111');
      expect(pledges.first.pledgeGroupName, '2026 Pledge Campaign');
      expect(pledges.first.goalName, 'Building Fund');
      expect(pledges.first.amount, 25.5);
      expect(pledges.first.goalAmount, 306);
      expect(pledges.first.startDate, '2026-01-01T00:00:00Z');
      expect(pledges.first.endDate, '2026-12-31T00:00:00Z');
      expect(pledges.last.goalName, 'Youth Ministry');
    });

    test('toPledges keeps next execution as original wall-clock API date', () {
      const executionDate = '2026-08-31T00:00:00Z';
      final group = PledgeGroup.fromJson({
        'pledgeGroupId': 'pg-1',
        'pledgeGroupName': 'Campaign',
        'collectGroupId': 'cg-1',
        'collectGroupNamespace': 'org',
        'collectGroupName': 'Church',
        'startDate': '2026-01-01T00:00:00Z',
        'endDate': '2026-12-31T00:00:00Z',
        'goals': [
          {
            'id': 'goal-row-1',
            'goalId': 'goal-1',
            'goalName': 'Building Fund',
            'totalAmount': 1598,
            'type': 'DirectDebit',
            'frequency': 'Monthly',
            'transactions': [
              {
                'id': 'tx-1',
                'amount': 266.32,
                'executionDate': executionDate,
                'state': 'Entered',
              },
            ],
          },
        ],
      });

      final pledges = group.toPledges();
      expect(pledges, hasLength(1));

      final pledge = pledges.first;
      expect(pledge.nextExecutionDate, executionDate);
      expect(pledge.nextExecutionDateTime, isNotNull);
      expect(pledge.nextExecutionDateTime!.year, 2026);
      expect(pledge.nextExecutionDateTime!.month, 8);
      expect(pledge.nextExecutionDateTime!.day, 31);

      final card = PledgeOverviewCard.fromPledges(pledges);
      final cardDate = card.earliestNextExecution;
      expect(cardDate, isNotNull);
      expect(cardDate!.year, 2026);
      expect(cardDate.month, 8);
      expect(cardDate.day, 31);
    });
  });

  group('Pledge', () {
    const sampleGroupJson = {
      'pledgeGroupId': 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      'pledgeGroupName': '2026 Pledge Campaign',
      'collectGroupId': 'f9e8d7c6-b5a4-3210-fedc-ba0987654321',
      'collectGroupNamespace': 'stmarys',
      'collectGroupName': "St. Mary's Church",
      'startDate': '2026-01-01T00:00:00Z',
      'endDate': '2026-12-31T00:00:00Z',
      'goals': [
        {
          'id': '11111111-1111-1111-1111-111111111111',
          'goalId': '22222222-2222-2222-2222-222222222222',
          'goalName': 'Building Fund',
          'totalAmount': 1500,
          'type': 'Online',
          'transactions': [
            {
              'id': 'tx-1',
              'amount': 25.50,
              'executionDate': '2026-08-01T00:00:00Z',
              'state': 'Entered',
            },
          ],
        },
      ],
    };

    test('fromApiItems flattens all pledge groups', () {
      final pledges = Pledge.fromApiItems([sampleGroupJson, sampleGroupJson]);

      expect(pledges, hasLength(2));
      expect(pledges.first.goalAmount, 1500);
      expect(pledges.first.paidAmount, 0);
    });

    test('fromApiItems handles empty goals list', () {
      final json = Map<String, dynamic>.from(sampleGroupJson)..['goals'] = [];

      final pledges = Pledge.fromApiItems([json]);

      expect(pledges, isEmpty);
    });
  });
}
