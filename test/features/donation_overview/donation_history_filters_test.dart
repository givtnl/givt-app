import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';

void main() {
  group('DonationHistoryFilters', () {
    final now = DateTime(2026, 9, 12);

    test('orderedDimensions puts active chips first in selection order', () {
      var filters = DonationHistoryFilters.empty
          .toggleType(DonationHistoryTypeFilter.oneOff)
          .toggleSource(DonationHistorySourceFilter.external)
          .toggleCategory(DonationHistoryCategoryFilter.church);

      expect(filters.orderedDimensions(), [
        DonationHistoryFilterDimension.type,
        DonationHistoryFilterDimension.source,
        DonationHistoryFilterDimension.categories,
        DonationHistoryFilterDimension.dateRange,
      ]);

      filters = filters.toggleType(DonationHistoryTypeFilter.oneOff);

      expect(filters.orderedDimensions(), [
        DonationHistoryFilterDimension.source,
        DonationHistoryFilterDimension.categories,
        DonationHistoryFilterDimension.type,
        DonationHistoryFilterDimension.dateRange,
      ]);
    });

    test(
      'single-select source deselects when the same chip is tapped again',
      () {
        final filters = DonationHistoryFilters.empty
            .toggleSource(DonationHistorySourceFilter.givtProcessed)
            .toggleSource(DonationHistorySourceFilter.givtProcessed);

        expect(filters.source, isNull);
        expect(filters.hasActive, isFalse);
      },
    );

    test('date presets fill from and to dates', () {
      final filters = DonationHistoryFilters.empty.toggleDatePreset(
        DonationHistoryDatePreset.thisMonth,
        now: now,
      );

      expect(filters.datePreset, DonationHistoryDatePreset.thisMonth);
      expect(filters.startDate, DateTime(2026, 9));
      expect(filters.endDate, DateTime(2026, 9, 12));

      final lastMonth = DonationHistoryFilters.empty.toggleDatePreset(
        DonationHistoryDatePreset.lastMonth,
        now: now,
      );
      expect(lastMonth.startDate, DateTime(2026, 8));
      expect(lastMonth.endDate, DateTime(2026, 8, 31));

      final lastThree = DonationHistoryFilters.empty.toggleDatePreset(
        DonationHistoryDatePreset.lastThreeMonths,
        now: now,
      );
      expect(lastThree.startDate, DateTime(2026, 7));
      expect(lastThree.endDate, DateTime(2026, 9, 12));
    });
  });

  group('DonationHistoryFilter', () {
    test('filters by source, type, category, and date range', () {
      final givtChurch = _item(
        id: 1,
        collectGroupType: 'Church',
        donationType: 1,
        timeStamp: DateTime(2026, 9, 10),
      );
      final givtCharity = _item(
        id: 2,
        collectGroupType: 'Charities',
        timeStamp: DateTime(2026, 8, 2),
      );
      final external = _item(
        id: 3,
        isExternal: true,
        externalFrequency: ExternalDonationFrequency.monthly,
        timeStamp: DateTime(2026, 9, 1),
      );

      expect(
        DonationHistoryFilter.apply(
          [givtChurch, givtCharity, external],
          DonationHistoryFilters.empty.toggleSource(
            DonationHistorySourceFilter.external,
          ),
        ),
        [external],
      );

      expect(
        DonationHistoryFilter.apply(
          [givtChurch, givtCharity, external],
          DonationHistoryFilters.empty.toggleType(
            DonationHistoryTypeFilter.recurring,
          ),
        ),
        [givtChurch, external],
      );

      expect(
        DonationHistoryFilter.apply(
          [givtChurch, givtCharity, external],
          DonationHistoryFilters.empty.toggleCategory(
            DonationHistoryCategoryFilter.church,
          ),
        ),
        [givtChurch],
      );

      expect(
        DonationHistoryFilter.apply(
          [givtChurch, givtCharity, external],
          DonationHistoryFilters.empty.setCustomDates(
            startDate: DateTime(2026, 9),
            endDate: DateTime(2026, 9, 12),
          ),
        ),
        [givtChurch, external],
      );
    });

    test('maps unknown and external rows to Other', () {
      expect(
        DonationHistoryFilter.categoryOf(_item(id: 1, isExternal: true)),
        DonationHistoryCategoryFilter.other,
      );
      expect(
        DonationHistoryFilter.categoryOf(
          _item(id: 2, collectGroupType: 'Artists'),
        ),
        DonationHistoryCategoryFilter.other,
      );
    });

    test('excludes rows without a timestamp when a date filter is set', () {
      final undated = _item(id: 1, hasTimestamp: false);
      final dated = _item(id: 2, timeStamp: DateTime(2026, 9, 1));

      expect(
        DonationHistoryFilter.apply(
          [undated, dated],
          DonationHistoryFilters.empty.setCustomDates(
            startDate: DateTime(2026, 9),
            endDate: DateTime(2026, 9, 12),
          ),
        ),
        [dated],
      );
    });
  });
}

DonationItem _item({
  required int id,
  bool isExternal = false,
  int donationType = 0,
  String? collectGroupType,
  DateTime? timeStamp,
  bool hasTimestamp = true,
  ExternalDonationFrequency? externalFrequency,
}) {
  return DonationItem(
    id: id,
    amount: 10,
    organisationName: 'Org',
    organisationTaxDeductible: false,
    isGiftAidEnabled: false,
    status: DonationStatus.fromLegacyStatus(3),
    timeStamp: hasTimestamp ? (timeStamp ?? DateTime(2026, 3, 15)) : null,
    mediumId: '',
    taxYear: 0,
    donationType: donationType,
    isExternal: isExternal,
    collectGroupType: collectGroupType,
    externalFrequency: externalFrequency,
  );
}
