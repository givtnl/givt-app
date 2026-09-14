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

    test(
      'applyMonthFilter keeps category and sets inclusive month bounds',
      () {
        final filters = PersonalSummaryHistoryFilters.applyMonthFilter(
          PersonalSummaryHistoryFilters.forCategory(GivingCategory.charity),
          year: 2026,
          month: 1,
        );

        expect(filters.categories, {DonationHistoryCategoryFilter.charity});
        expect(filters.startDate, DateTime(2026, 1));
        expect(filters.endDate, DateTime(2026, 1, 31));
        expect(filters.source, isNull);
        expect(filters.type, isNull);
        expect(filters.orderedDimensions(), [
          DonationHistoryFilterDimension.categories,
          DonationHistoryFilterDimension.dateRange,
          DonationHistoryFilterDimension.source,
          DonationHistoryFilterDimension.type,
        ]);
        expect(filters.toQueryParameters(), {
          'category': 'charity',
          'startDate': DateTime(2026, 1).toIso8601String(),
          'endDate': DateTime(2026, 1, 31).toIso8601String(),
        });
      },
    );

    test('applyMonthFilter keeps donation type and source filters', () {
      final typed = PersonalSummaryHistoryFilters.applyMonthFilter(
        PersonalSummaryHistoryFilters.forDonationType(recurring: true),
        year: 2026,
        month: 3,
      );
      expect(typed.type, DonationHistoryTypeFilter.recurring);
      expect(typed.startDate, DateTime(2026, 3));
      expect(typed.endDate, DateTime(2026, 3, 31));
      expect(typed.toQueryParameters(), {
        'type': 'recurring',
        'startDate': DateTime(2026, 3).toIso8601String(),
        'endDate': DateTime(2026, 3, 31).toIso8601String(),
      });

      final sourced = PersonalSummaryHistoryFilters.applyMonthFilter(
        PersonalSummaryHistoryFilters.forSource(givtProcessed: false),
        year: 2026,
        month: 12,
      );
      expect(sourced.source, DonationHistorySourceFilter.external);
      expect(sourced.startDate, DateTime(2026, 12));
      expect(sourced.endDate, DateTime(2026, 12, 31));
      expect(sourced.toQueryParameters(), {
        'source': 'external',
        'startDate': DateTime(2026, 12).toIso8601String(),
        'endDate': DateTime(2026, 12, 31).toIso8601String(),
      });
    });
  });
}
