import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';

abstract final class PersonalSummaryHistoryFilters {
  const PersonalSummaryHistoryFilters._();

  static DonationHistoryFilters forCategory(GivingCategory category) {
    return DonationHistoryFilters(
      categories: {_categoryOf(category)},
      selectionOrder: const [DonationHistoryFilterDimension.categories],
    );
  }

  /// Inclusive local 1 January through 31 December of [year].
  static DonationHistoryFilters applyYearFilter(
    DonationHistoryFilters filters, {
    required int year,
  }) {
    return filters.setCustomDates(
      startDate: DateTime(year),
      endDate: DateTime(year, 12, 31),
    );
  }

  /// Inclusive local first and last day of [month] in [year].
  static DonationHistoryFilters applyMonthFilter(
    DonationHistoryFilters filters, {
    required int year,
    required int month,
  }) {
    return filters.setCustomDates(
      startDate: DateTime(year, month),
      endDate: DateTime(year, month + 1, 0),
    );
  }

  static DonationHistoryFilters forMonth({
    required int year,
    required int month,
  }) {
    return applyMonthFilter(
      DonationHistoryFilters.empty,
      year: year,
      month: month,
    );
  }

  static DonationHistoryFilters forDonationType({required bool recurring}) {
    return DonationHistoryFilters.empty.toggleType(
      recurring
          ? DonationHistoryTypeFilter.recurring
          : DonationHistoryTypeFilter.oneOff,
    );
  }

  static DonationHistoryFilters forSource({required bool givtProcessed}) {
    return DonationHistoryFilters.empty.toggleSource(
      givtProcessed
          ? DonationHistorySourceFilter.givtProcessed
          : DonationHistorySourceFilter.external,
    );
  }

  static DonationHistoryCategoryFilter _categoryOf(GivingCategory category) {
    return switch (category) {
      GivingCategory.charity => DonationHistoryCategoryFilter.charity,
      GivingCategory.church => DonationHistoryCategoryFilter.church,
      GivingCategory.campaign => DonationHistoryCategoryFilter.campaign,
      GivingCategory.other => DonationHistoryCategoryFilter.other,
    };
  }
}
