import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/models/for_you_goal_line.dart';
import 'package:givt_app/features/give/utils/for_you_giving_analytics.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';

void main() {
  group('buildForYouGivingContinueAnalyticsParameters', () {
    test('maps collection and general goal amounts', () {
      final lines = <ForYouGoalLineKind>[
        const ForYouCollectionGoalLine(
          title: 'Building fund',
          subtitleIndex: 1,
        ),
        const ForYouCollectionGoalLine(
          title: 'Youth',
          subtitleIndex: 2,
        ),
        ForYouGeneralGoalLine(
          OrganisationQrCode(
            mediumId: 'qr.medium',
            allocationName: 'Mission',
            collectGroupId: 'g',
          ),
        ),
      ];

      final parameters = buildForYouGivingContinueAnalyticsParameters(
        lines: lines,
        amountTexts: ['10', '0', '5,50'],
      );

      expect(parameters, {
        'Collection 1': '10',
        'Collection 2': '0',
        'General goal: Mission': '5,50',
      });
    });

    test('uses ordinal when general goal has no allocation name', () {
      final lines = <ForYouGoalLineKind>[
        ForYouGeneralGoalLine(
          OrganisationQrCode(
            mediumId: 'qr.medium',
            allocationName: '   ',
            collectGroupId: 'g',
          ),
        ),
      ];

      final parameters = buildForYouGivingContinueAnalyticsParameters(
        lines: lines,
        amountTexts: ['3'],
      );

      expect(parameters, {'General goal 1': '3'});
    });
  });
}
