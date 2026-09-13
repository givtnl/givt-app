import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';

/// Maps personal-summary taps onto the ENG-1428 history filter contract.
/// Each helper applies **one** filter so history opens with a single
/// chip active.
abstract final class PersonalSummaryHistoryFilters {
  const PersonalSummaryHistoryFilters._();

  static DonationHistoryFilters forCategory(GivingCategory category) {
    return DonationHistoryFilters(
      categories: {_categoryOf(category)},
      selectionOrder: const [DonationHistoryFilterDimension.categories],
    );
  }

  static DonationHistoryFilters forMonth({
    required int year,
    required int month,
  }) {
    return DonationHistoryFilters.empty.setCustomDates(
      startDate: DateTime(year, month),
      endDate: DateTime(year, month + 1, 0),
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
