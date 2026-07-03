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
          'amount': 25.50,
          'frequency': 'Monthly',
          'type': 'Online',
          'nextExecutionDate': '2026-08-01T00:00:00Z',
        },
        {
          'id': '33333333-3333-3333-3333-333333333333',
          'goalId': '44444444-4444-4444-4444-444444444444',
          'goalName': 'Youth Ministry',
          'amount': 10.00,
          'frequency': 'Weekly',
          'type': 'DirectDebit',
          'nextExecutionDate': '2026-08-01T00:00:00Z',
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
      expect(group.goals.last.type, 'DirectDebit');
    });

    test('toPledges flattens goals with campaign metadata', () {
      final pledges = PledgeGroup.fromJson(sampleGroupJson).toPledges();

      expect(pledges, hasLength(2));
      expect(pledges.first.id, '11111111-1111-1111-1111-111111111111');
      expect(pledges.first.pledgeGroupName, '2026 Pledge Campaign');
      expect(pledges.first.goalName, 'Building Fund');
      expect(pledges.first.amount, 25.5);
      expect(pledges.first.frequency, 'Monthly');
      expect(pledges.first.startDate, '2026-01-01T00:00:00Z');
      expect(pledges.first.endDate, '2026-12-31T00:00:00Z');
      expect(pledges.last.goalName, 'Youth Ministry');
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
          'goalAmount': 1500,
          'amount': 25.50,
          'frequency': 'Monthly',
          'type': 'Online',
          'nextExecutionDate': '2026-08-01T00:00:00Z',
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
