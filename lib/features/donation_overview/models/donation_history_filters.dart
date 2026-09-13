import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:intl/intl.dart';

/// Top-level donation-history filter chips, in default (unselected) order.
enum DonationHistoryFilterDimension { source, type, categories, dateRange }

enum DonationHistorySourceFilter { givtProcessed, external }

enum DonationHistoryTypeFilter { oneOff, recurring }

enum DonationHistoryCategoryFilter { charity, church, campaign, other }

enum DonationHistoryDatePreset { thisMonth, lastMonth, lastThreeMonths }

class DonationHistoryFilters extends Equatable {
  const DonationHistoryFilters({
    this.source,
    this.type,
    this.categories = const {},
    this.startDate,
    this.endDate,
    this.datePreset,
    this.selectionOrder = const [],
  });

  static const empty = DonationHistoryFilters();

  final DonationHistorySourceFilter? source;
  final DonationHistoryTypeFilter? type;
  final Set<DonationHistoryCategoryFilter> categories;
  final DateTime? startDate;
  final DateTime? endDate;
  final DonationHistoryDatePreset? datePreset;
  final List<DonationHistoryFilterDimension> selectionOrder;

  bool get hasActive =>
      source != null ||
      type != null ||
      categories.isNotEmpty ||
      startDate != null ||
      endDate != null;

  bool isDimensionActive(DonationHistoryFilterDimension dimension) {
    return switch (dimension) {
      DonationHistoryFilterDimension.source => source != null,
      DonationHistoryFilterDimension.type => type != null,
      DonationHistoryFilterDimension.categories => categories.isNotEmpty,
      DonationHistoryFilterDimension.dateRange =>
        startDate != null || endDate != null,
    };
  }

  /// Active chips first (in the order they were selected), then the rest
  /// in the default order.
  List<DonationHistoryFilterDimension> orderedDimensions() {
    const defaults = DonationHistoryFilterDimension.values;
    final active = selectionOrder.where(isDimensionActive).toList();
    final inactive = defaults.where((d) => !isDimensionActive(d)).toList();
    return [...active, ...inactive];
  }

  DonationHistoryFilters copyWith({
    DonationHistorySourceFilter? source,
    bool clearSource = false,
    DonationHistoryTypeFilter? type,
    bool clearType = false,
    Set<DonationHistoryCategoryFilter>? categories,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    DonationHistoryDatePreset? datePreset,
    bool clearDatePreset = false,
    List<DonationHistoryFilterDimension>? selectionOrder,
  }) {
    return DonationHistoryFilters(
      source: clearSource ? null : (source ?? this.source),
      type: clearType ? null : (type ?? this.type),
      categories: categories ?? this.categories,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      datePreset: clearDatePreset ? null : (datePreset ?? this.datePreset),
      selectionOrder: selectionOrder ?? this.selectionOrder,
    );
  }

  DonationHistoryFilters toggleSource(DonationHistorySourceFilter value) {
    final next = source == value ? null : value;
    return copyWith(
      source: next,
      clearSource: next == null,
      selectionOrder: _orderFor(
        DonationHistoryFilterDimension.source,
        isActive: next != null,
      ),
    );
  }

  DonationHistoryFilters toggleType(DonationHistoryTypeFilter value) {
    final next = type == value ? null : value;
    return copyWith(
      type: next,
      clearType: next == null,
      selectionOrder: _orderFor(
        DonationHistoryFilterDimension.type,
        isActive: next != null,
      ),
    );
  }

  DonationHistoryFilters toggleCategory(DonationHistoryCategoryFilter value) {
    final next = {...categories};
    if (!next.add(value)) {
      next.remove(value);
    }
    return copyWith(
      categories: next,
      selectionOrder: _orderFor(
        DonationHistoryFilterDimension.categories,
        isActive: next.isNotEmpty,
      ),
    );
  }

  DonationHistoryFilters toggleDatePreset(
    DonationHistoryDatePreset preset, {
    required DateTime now,
  }) {
    if (datePreset == preset) {
      return copyWith(
        clearDatePreset: true,
        clearStartDate: true,
        clearEndDate: true,
        selectionOrder: _orderFor(
          DonationHistoryFilterDimension.dateRange,
          isActive: false,
        ),
      );
    }

    final range = dateRangeForPreset(preset, now);
    return copyWith(
      datePreset: preset,
      startDate: range.start,
      endDate: range.end,
      selectionOrder: _orderFor(
        DonationHistoryFilterDimension.dateRange,
        isActive: true,
      ),
    );
  }

  DonationHistoryFilters setCustomDates({
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    final nextStart = clearStartDate ? null : (startDate ?? this.startDate);
    final nextEnd = clearEndDate ? null : (endDate ?? this.endDate);
    final matchingPreset = _presetMatching(nextStart, nextEnd, DateTime.now());
    return copyWith(
      startDate: nextStart,
      clearStartDate: nextStart == null,
      endDate: nextEnd,
      clearEndDate: nextEnd == null,
      datePreset: matchingPreset,
      clearDatePreset: matchingPreset == null,
      selectionOrder: _orderFor(
        DonationHistoryFilterDimension.dateRange,
        isActive: nextStart != null || nextEnd != null,
      ),
    );
  }

  List<DonationHistoryFilterDimension> _orderFor(
    DonationHistoryFilterDimension dimension, {
    required bool isActive,
  }) {
    final order = [...selectionOrder]..remove(dimension);
    if (isActive) {
      order.add(dimension);
    }
    return order;
  }

  static ({DateTime start, DateTime end}) dateRangeForPreset(
    DonationHistoryDatePreset preset,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case DonationHistoryDatePreset.thisMonth:
        return (start: DateTime(now.year, now.month), end: today);
      case DonationHistoryDatePreset.lastMonth:
        final start = DateTime(now.year, now.month - 1);
        final end = DateTime(now.year, now.month, 0);
        return (start: start, end: end);
      case DonationHistoryDatePreset.lastThreeMonths:
        return (start: DateTime(now.year, now.month - 2), end: today);
    }
  }

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  static DonationHistoryDatePreset? _presetMatching(
    DateTime? start,
    DateTime? end,
    DateTime now,
  ) {
    if (start == null || end == null) {
      return null;
    }
    for (final preset in DonationHistoryDatePreset.values) {
      final range = dateRangeForPreset(preset, now);
      if (startOfDay(start) == startOfDay(range.start) &&
          startOfDay(end) == startOfDay(range.end)) {
        return preset;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
    source,
    type,
    categories,
    startDate,
    endDate,
    datePreset,
    selectionOrder,
  ];
}

abstract final class DonationHistoryFilter {
  const DonationHistoryFilter._();

  static List<DonationItem> apply(
    List<DonationItem> donations,
    DonationHistoryFilters filters,
  ) {
    if (!filters.hasActive) {
      return donations;
    }
    return donations.where((item) => matches(item, filters)).toList();
  }

  static bool matches(DonationItem item, DonationHistoryFilters filters) {
    if (filters.source == DonationHistorySourceFilter.givtProcessed &&
        item.isExternal) {
      return false;
    }
    if (filters.source == DonationHistorySourceFilter.external &&
        !item.isExternal) {
      return false;
    }

    if (filters.type != null) {
      final recurring = isRecurring(item);
      if (filters.type == DonationHistoryTypeFilter.recurring && !recurring) {
        return false;
      }
      if (filters.type == DonationHistoryTypeFilter.oneOff && recurring) {
        return false;
      }
    }

    if (filters.categories.isNotEmpty &&
        !filters.categories.contains(categoryOf(item))) {
      return false;
    }

    final timestamp = item.timeStamp;
    if (filters.startDate != null || filters.endDate != null) {
      if (timestamp == null) {
        return false;
      }
      if (filters.startDate != null &&
          timestamp.isBefore(
            DonationHistoryFilters.startOfDay(filters.startDate!),
          )) {
        return false;
      }
      if (filters.endDate != null &&
          timestamp.isAfter(
            DonationHistoryFilters.endOfDay(filters.endDate!),
          )) {
        return false;
      }
    }

    return true;
  }

  static bool isRecurring(DonationItem item) {
    if (item.isExternal) {
      return item.isExternalRecurring;
    }
    return item.donationType == 1;
  }

  static DonationHistoryCategoryFilter categoryOf(DonationItem item) {
    if (item.isExternal) {
      return DonationHistoryCategoryFilter.other;
    }
    final type = CollectGroupType.fromString(item.collectGroupType ?? '');
    return switch (type) {
      CollectGroupType.church => DonationHistoryCategoryFilter.church,
      CollectGroupType.charities => DonationHistoryCategoryFilter.charity,
      CollectGroupType.campaign => DonationHistoryCategoryFilter.campaign,
      CollectGroupType.artists ||
      CollectGroupType.unknown ||
      CollectGroupType.demo ||
      CollectGroupType.debug ||
      CollectGroupType.none => DonationHistoryCategoryFilter.other,
    };
  }
}

/// Compact locale date for the filter From/To fields (no weekday).
///
/// Uses the locale short date with a two-digit year, e.g. `9/10/26` in
/// en-US, so it fits the 160px inputs next to the calendar icon.
String formatDonationHistoryFilterDate(DateTime date, String locale) {
  return DateFormat.yMd(locale)
      .format(date)
      .replaceFirstMapped(
        RegExp(r'\d{4}'),
        (match) => match[0]!.substring(2),
      );
}
