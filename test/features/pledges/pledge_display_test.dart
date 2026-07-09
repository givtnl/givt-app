import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';

void main() {
  group('PledgeDisplay.buildGroupCardProgress', () {
    const collectGroup = PledgeCollectGroup(
      id: 'cg-1',
      namespace: 'org.example',
      name: 'Example Church',
    );

    test('returns combined progress for pledge group card', () {
      final card = PledgeOverviewCard.fromPledges([
        const Pledge(
          id: '1',
          goalId: 'goal-1',
          pledgeGroupId: 'pg-1',
          type: 'DirectDebit',
          amount: 26,
          frequency: 'Yearly',
          collectGroup: collectGroup,
          pledgeGroupName: 'Campaign',
          goalName: 'Church balance',
          goalAmount: 26,
        ),
        const Pledge(
          id: '2',
          goalId: 'goal-2',
          pledgeGroupId: 'pg-1',
          type: 'DirectDebit',
          amount: 15,
          frequency: 'Yearly',
          collectGroup: collectGroup,
          pledgeGroupName: 'Campaign',
          goalName: 'Mission',
          goalAmount: 15,
        ),
      ]);

      final progress = PledgeDisplay.buildGroupCardProgress(
        card: card,
        countryCode: 'NL',
      );

      expect(progress, isNotNull);
      expect(progress!.totalAmount, 41);
      expect(progress.displayText, contains('41'));
    });
  });
}
