import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/domain/personal_summary_aggregation.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/giving_goal.dart';
import 'package:givt_app/shared/models/givt.dart';

void main() {
  group('personal_summary_aggregation', () {
    final collectGroups = [
      const CollectGroup(
        nameSpace: 'church-ns',
        orgName: 'My Church',
        hasCelebration: false,
        type: CollectGroupType.church,
      ),
      const CollectGroup(
        nameSpace: 'charity-ns',
        orgName: 'My Charity',
        hasCelebration: false,
        type: CollectGroupType.charities,
      ),
    ];

    test('maps givt to category via mediumId namespace join', () {
      final givt = Givt(
        id: 1,
        amount: 10,
        collectGroupId: 'guid-1',
        organisationName: 'My Church',
        organisationTaxDeductible: true,
        collectId: 1,
        isGiftAidEnabled: false,
        status: 3,
        timeStamp: DateTime(2025, 3, 15),
        mediumId: 'church-ns.location',
        taxYear: 0,
        donationType: 0,
      );

      final category = categoryForGivt(givt, collectGroups);
      expect(category, GivingCategory.church);
    });

    test('builds yearly totals, monthly matrix, and splits', () {
      final givts = [
        Givt(
          id: 1,
          amount: 20,
          collectGroupId: 'guid-1',
          organisationName: 'My Church',
          organisationTaxDeductible: true,
          collectId: 1,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2025, 1, 10),
          mediumId: 'church-ns.location',
          taxYear: 0,
          donationType: 1,
        ),
        Givt(
          id: 2,
          amount: 30,
          collectGroupId: 'guid-2',
          organisationName: 'My Charity',
          organisationTaxDeductible: true,
          collectId: 2,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2025, 2, 5),
          mediumId: 'charity-ns.location',
          taxYear: 0,
        ),
      ];

      final external = [
        const ExternalDonation(
          id: 'ext-1',
          amount: 10,
          description: 'External',
          frequencyString: 'Once',
          creationDate: '2025-03-01T00:00:00',
          taxDeductible: false,
          startDate: '2025-03-01T00:00:00',
        ),
      ];

      final uiModel = buildPersonalSummaryUIModel(
        allGivts: givts,
        allExternalDonations: external,
        collectGroups: collectGroups,
        givingGoal: const GivingGoal(amount: 100, frequency: GivingGoalFrequency.annually),
        selectedYear: 2025,
      );

      expect(uiModel.yearTotal, 60);
      expect(uiModel.categorySegments.firstWhere((s) => s.category == GivingCategory.church).amount, 20);
      expect(uiModel.categorySegments.firstWhere((s) => s.category == GivingCategory.charity).amount, 30);
      expect(uiModel.categorySegments.firstWhere((s) => s.category == GivingCategory.other).amount, 10);
      expect(
        uiModel.categorySegments.map((segment) => segment.category).toList(),
        [
          GivingCategory.charity,
          GivingCategory.church,
          GivingCategory.other,
          GivingCategory.campaign,
        ],
      );
      expect(uiModel.monthlyRows[0].total, 20);
      expect(uiModel.monthlyRows[1].total, 30);
      expect(uiModel.monthlyRows[2].total, 10);
      expect(uiModel.recurringSplit.primaryAmount, 20);
      expect(uiModel.recurringSplit.secondaryAmount, 40);
      expect(uiModel.givtVsExternalSplit.primaryAmount, 50);
      expect(uiModel.givtVsExternalSplit.secondaryAmount, 10);
      expect(uiModel.goalProgress, closeTo(0.6, 0.001));
    });

    test('always includes current calendar year in available years', () {
      final givts = [
        Givt(
          id: 1,
          amount: 50,
          collectGroupId: 'guid-1',
          organisationName: 'My Church',
          organisationTaxDeductible: true,
          collectId: 1,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2023, 6, 1),
          mediumId: 'church-ns.location',
          taxYear: 0,
        ),
      ];

      final years = deriveAvailableYears(
        givts: givts,
        externalDonations: const [],
      );

      expect(years, contains(DateTime.now().year));
      expect(years.first, DateTime.now().year);
    });

    test('excludes refused and cancelled givts', () {
      final givts = [
        Givt(
          id: 1,
          amount: 100,
          collectGroupId: 'guid-1',
          organisationName: 'My Church',
          organisationTaxDeductible: true,
          collectId: 1,
          isGiftAidEnabled: false,
          status: 4,
          timeStamp: DateTime(2025, 1, 10),
          mediumId: 'church-ns.location',
          taxYear: 0,
        ),
      ];

      final uiModel = buildPersonalSummaryUIModel(
        allGivts: givts,
        allExternalDonations: const [],
        collectGroups: collectGroups,
        givingGoal: const GivingGoal.empty(),
        selectedYear: 2025,
      );

      expect(uiModel.yearTotal, 0);
      expect(uiModel.hasDonationsInYear, isFalse);
    });

    test('orders category segments descending by amount', () {
      final collectGroupsWithCampaign = [
        ...collectGroups,
        const CollectGroup(
          nameSpace: 'campaign-ns',
          orgName: 'My Campaign',
          hasCelebration: false,
          type: CollectGroupType.campaign,
        ),
      ];

      final givts = [
        Givt(
          id: 1,
          amount: 10,
          collectGroupId: 'guid-1',
          organisationName: 'My Campaign',
          organisationTaxDeductible: true,
          collectId: 1,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2025, 1, 10),
          mediumId: 'campaign-ns.location',
          taxYear: 0,
        ),
        Givt(
          id: 2,
          amount: 30,
          collectGroupId: 'guid-2',
          organisationName: 'My Church',
          organisationTaxDeductible: true,
          collectId: 2,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2025, 2, 5),
          mediumId: 'church-ns.location',
          taxYear: 0,
        ),
        Givt(
          id: 3,
          amount: 40,
          collectGroupId: 'guid-3',
          organisationName: 'My Charity',
          organisationTaxDeductible: true,
          collectId: 3,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2025, 3, 5),
          mediumId: 'charity-ns.location',
          taxYear: 0,
        ),
      ];

      final external = [
        const ExternalDonation(
          id: 'ext-1',
          amount: 20,
          description: 'External',
          frequencyString: 'Once',
          creationDate: '2025-04-01T00:00:00',
          taxDeductible: false,
          startDate: '2025-04-01T00:00:00',
        ),
      ];

      final uiModel = buildPersonalSummaryUIModel(
        allGivts: givts,
        allExternalDonations: external,
        collectGroups: collectGroupsWithCampaign,
        givingGoal: const GivingGoal.empty(),
        selectedYear: 2025,
      );

      expect(
        uiModel.categorySegments.map((segment) => segment.category).toList(),
        [
          GivingCategory.charity,
          GivingCategory.church,
          GivingCategory.other,
          GivingCategory.campaign,
        ],
      );
    });

    test('lists zero-donation categories below active categories alphabetically', () {
      final uiModel = buildPersonalSummaryUIModel(
        allGivts: const [],
        allExternalDonations: const [],
        collectGroups: collectGroups,
        givingGoal: const GivingGoal.empty(),
        selectedYear: 2025,
      );

      expect(
        uiModel.categorySegments.map((segment) => segment.category).toList(),
        [
          GivingCategory.campaign,
          GivingCategory.charity,
          GivingCategory.church,
          GivingCategory.other,
        ],
      );
    });

    test('uses alphabetical order for tied non-zero amounts', () {
      final givts = [
        Givt(
          id: 1,
          amount: 50,
          collectGroupId: 'guid-1',
          organisationName: 'My Church',
          organisationTaxDeductible: true,
          collectId: 1,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2025, 1, 10),
          mediumId: 'church-ns.location',
          taxYear: 0,
        ),
        Givt(
          id: 2,
          amount: 50,
          collectGroupId: 'guid-2',
          organisationName: 'My Charity',
          organisationTaxDeductible: true,
          collectId: 2,
          isGiftAidEnabled: false,
          status: 3,
          timeStamp: DateTime(2025, 2, 5),
          mediumId: 'charity-ns.location',
          taxYear: 0,
        ),
      ];

      final uiModel = buildPersonalSummaryUIModel(
        allGivts: givts,
        allExternalDonations: const [],
        collectGroups: collectGroups,
        givingGoal: const GivingGoal.empty(),
        selectedYear: 2025,
      );

      expect(
        uiModel.categorySegments.map((segment) => segment.category).toList(),
        [
          GivingCategory.charity,
          GivingCategory.church,
          GivingCategory.campaign,
          GivingCategory.other,
        ],
      );
    });

    test('compareCategorySegments sorts active before zero amounts', () {
      const active = ChartSegment(
        category: GivingCategory.charity,
        amount: 10,
        fraction: 1,
      );
      const zero = ChartSegment(
        category: GivingCategory.campaign,
        amount: 0,
        fraction: 0,
      );

      expect(compareCategorySegments(active, zero), lessThan(0));
      expect(compareCategorySegments(zero, active), greaterThan(0));
    });
  });
}
