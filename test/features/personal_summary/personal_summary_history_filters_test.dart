import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/personal_summary/domain/personal_summary_history_filters.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';

void main() {
  group('PersonalSummaryHistoryFilters', () {
    test('category tap applies only that category', () {
      final filters = PersonalSummaryHistoryFilters.forCategory(
        GivingCategory.charity,
      );

      expect(filters.categories, {DonationHistoryCategoryFilter.charity});
      expect(filters.source, isNull);
      expect(filters.type, isNull);
      expect(filters.startDate, isNull);
      expect(filters.endDate, isNull);
      expect(
        filters.orderedDimensions().first,
        DonationHistoryFilterDimension.categories,
      );
      expect(filters.toQueryParameters(), {'category': 'charity'});
    });

    test('month tap uses inclusive local first and last day', () {
      final filters = PersonalSummaryHistoryFilters.forMonth(
        year: 2026,
        month: 1,
      );

      expect(filters.startDate, DateTime(2026, 1));
      expect(filters.endDate, DateTime(2026, 1, 31));
      expect(filters.source, isNull);
      expect(filters.type, isNull);
      expect(filters.categories, isEmpty);
      expect(
        filters.orderedDimensions().first,
        DonationHistoryFilterDimension.dateRange,
      );
    });

    test('split taps apply a single type or source filter', () {
      final recurring = PersonalSummaryHistoryFilters.forDonationType(
        recurring: true,
      );
      expect(recurring.type, DonationHistoryTypeFilter.recurring);
      expect(recurring.source, isNull);

      final external = PersonalSummaryHistoryFilters.forSource(
        givtProcessed: false,
      );
      expect(external.source, DonationHistorySourceFilter.external);
      expect(external.type, isNull);
    });
  });
}
