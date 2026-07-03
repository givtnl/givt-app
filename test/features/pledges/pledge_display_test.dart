import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/features/pledges/shared/pledge_display.dart';
import 'package:givt_app/l10n/arb/app_localizations_en.dart';

void main() {
  group('PledgeDisplay.buildCardProgress', () {
    const collectGroup = PledgeCollectGroup(
      id: 'cg-1',
      namespace: 'org.example',
      name: 'Example Church',
    );

    test('returns progress with formatted currency labels', () {
      final progress = PledgeDisplay.buildCardProgress(
        pledge: const Pledge(
          id: '1',
          goalId: 'goal-1',
          pledgeGroupId: 'pg-1',
          type: 'DirectDebit',
          amount: 26,
          frequency: 'Yearly',
          collectGroup: collectGroup,
          pledgeGroupName: 'Campaign',
          goalName: 'Building fund',
          goalAmount: 1500,
        ),
        countryCode: 'NL',
      );

      expect(progress, isNotNull);
      expect(progress!.amount, 0);
      expect(progress.displayText, contains('€0'));
      expect(progress.displayText, contains('1500'));
    });

    test(
      'returns progress using pledge amount for all-at-once without goalAmount',
      () {
        final progress = PledgeDisplay.buildCardProgress(
          pledge: const Pledge(
            id: '1',
            goalId: 'goal-1',
            pledgeGroupId: 'pg-1',
            type: 'DirectDebit',
            amount: 26,
            frequency: 'Yearly',
            collectGroup: collectGroup,
            pledgeGroupName: 'Campaign',
            goalName: 'Building fund',
          ),
          countryCode: 'NL',
        );

        expect(progress, isNotNull);
        expect(progress!.totalAmount, 26);
      },
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

  group('PledgeDisplay.buildManageFrequencySubtitle', () {
    const collectGroup = PledgeCollectGroup(
      id: 'cg-1',
      namespace: 'org.example',
      name: 'Example Church',
    );

    test('shows mixed-frequency label when goals differ', () {
      final group = PledgeGroup(
        pledgeGroupId: 'pg-1',
        pledgeGroupName: 'Campaign',
        collectGroup: collectGroup,
        startDate: null,
        endDate: null,
        goals: const [
          PledgeGoal(
            id: '1',
            goalId: 'goal-1',
            goalName: 'Building fund',
            amount: 10,
            frequency: 'Monthly',
            type: 'Online',
          ),
          PledgeGoal(
            id: '2',
            goalId: 'goal-2',
            goalName: 'Mission',
            amount: 15,
            frequency: 'Weekly',
            type: 'Online',
          ),
        ],
      );

      final subtitle = PledgeDisplay.buildManageFrequencySubtitle(
        locals: AppLocalizationsEn(),
        group: group,
        locale: 'en',
      );

      expect(subtitle, 'Multiple frequencies');
    });
  });
}
