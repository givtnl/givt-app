import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_uimodel.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/giving_goal.dart';
import 'package:givt_app/shared/models/givt.dart';

bool isIncludedGivtStatus(int status) =>
    status == 1 || status == 2 || status == 3;

/// Resolves a [Givt] to its [CollectGroup] via `mediumId.contains(nameSpace)`.
/// Longest matching namespace wins (same pattern as [CampaignRepository]).
CollectGroup? resolveCollectGroupForGivt(
  Givt givt,
  List<CollectGroup> collectGroups,
) {
  if (givt.mediumId.isEmpty) {
    return null;
  }

  CollectGroup? bestMatch;
  var bestLength = 0;
  for (final collectGroup in collectGroups) {
    final nameSpace = collectGroup.nameSpace;
    if (nameSpace.isEmpty) {
      continue;
    }
    if (givt.mediumId.contains(nameSpace) && nameSpace.length > bestLength) {
      bestMatch = collectGroup;
      bestLength = nameSpace.length;
    }
  }
  return bestMatch;
}

GivingCategory categoryForGivt(
  Givt givt,
  List<CollectGroup> collectGroups,
) {
  final collectGroup = resolveCollectGroupForGivt(givt, collectGroups);
  return GivingCategoryX.fromCollectGroupType(collectGroup?.type);
}

DateTime? donationDateForExternal(ExternalDonation donation) =>
    donation.startDateTime ?? donation.creationDateTime;

List<int> deriveAvailableYears({
  required List<Givt> givts,
  required List<ExternalDonation> externalDonations,
}) {
  final years = <int>{};

  for (final givt in givts) {
    if (!isIncludedGivtStatus(givt.status)) {
      continue;
    }
    final timestamp = givt.timeStamp;
    if (timestamp != null) {
      years.add(timestamp.year);
    }
  }

  for (final donation in externalDonations) {
    final date = donationDateForExternal(donation);
    if (date != null) {
      years.add(date.year);
    }
  }

  years.add(DateTime.now().year);

  final sorted = years.toList()..sort((a, b) => b.compareTo(a));
  return sorted;
}

List<Givt> givtsForYear(List<Givt> givts, int year) {
  return givts.where((givt) {
    if (!isIncludedGivtStatus(givt.status)) {
      return false;
    }
    final timestamp = givt.timeStamp;
    return timestamp != null && timestamp.year == year;
  }).toList();
}

List<ExternalDonation> externalDonationsForYear(
  List<ExternalDonation> externalDonations,
  int year,
) {
  return externalDonations.where((donation) {
    final date = donationDateForExternal(donation);
    return date != null && date.year == year;
  }).toList();
}

bool isInSelectedMonth(DateTime? date, int? selectedMonth) {
  if (selectedMonth == null) {
    return true;
  }
  return date != null && date.month == selectedMonth;
}

PersonalSummaryUIModel buildPersonalSummaryUIModel({
  required List<Givt> allGivts,
  required List<ExternalDonation> allExternalDonations,
  required List<CollectGroup> collectGroups,
  required GivingGoal givingGoal,
  required int selectedYear,
  int? selectedMonth,
}) {
  final availableYears = deriveAvailableYears(
    givts: allGivts,
    externalDonations: allExternalDonations,
  );

  final yearGivts = givtsForYear(allGivts, selectedYear);
  final yearExternal = externalDonationsForYear(
    allExternalDonations,
    selectedYear,
  );

  final periodCategoryTotals = {
    for (final category in GivingCategoryX.ordered) category: 0.0,
  };

  var yearGivtTotal = 0.0;
  var yearExternalTotal = 0.0;
  var periodGivtTotal = 0.0;
  var periodExternalTotal = 0.0;
  var periodRecurringTotal = 0.0;
  var periodOneOffTotal = 0.0;

  final monthlyTotals = {
    for (var month = 1; month <= 12; month++)
      month: {
        for (final category in GivingCategoryX.ordered) category: 0.0,
      },
  };

  for (final givt in yearGivts) {
    final amount = givt.amount;
    final category = categoryForGivt(givt, collectGroups);
    final month = givt.timeStamp?.month;
    yearGivtTotal += amount;

    if (month != null) {
      monthlyTotals[month]![category] =
          monthlyTotals[month]![category]! + amount;
    }

    if (!isInSelectedMonth(givt.timeStamp, selectedMonth)) {
      continue;
    }

    periodCategoryTotals[category] = periodCategoryTotals[category]! + amount;
    periodGivtTotal += amount;
    if (givt.donationType == 1) {
      periodRecurringTotal += amount;
    } else {
      periodOneOffTotal += amount;
    }
  }

  for (final donation in yearExternal) {
    final amount = donation.amount;
    final date = donationDateForExternal(donation);
    final month = date?.month;
    yearExternalTotal += amount;

    if (month != null) {
      monthlyTotals[month]![GivingCategory.other] =
          monthlyTotals[month]![GivingCategory.other]! + amount;
    }

    if (!isInSelectedMonth(date, selectedMonth)) {
      continue;
    }

    periodCategoryTotals[GivingCategory.other] =
        periodCategoryTotals[GivingCategory.other]! + amount;
    periodExternalTotal += amount;
    if (donation.isRecurring) {
      periodRecurringTotal += amount;
    } else {
      periodOneOffTotal += amount;
    }
  }

  final yearTotal = yearGivtTotal + yearExternalTotal;
  final periodTotal = periodGivtTotal + periodExternalTotal;
  final categorySegments = _buildCategorySegments(
    periodCategoryTotals,
    periodTotal,
  );
  final monthlyRows = _buildMonthlyRows(monthlyTotals);
  final recurringSplit = _buildSplit(periodRecurringTotal, periodOneOffTotal);
  final givtVsExternalSplit = _buildSplit(periodGivtTotal, periodExternalTotal);

  final goalAmount = givingGoal.yearlyGivingGoal;
  final goalProgress = goalAmount > 0
      ? (yearTotal / goalAmount).clamp(0.0, 1.0)
      : 0.0;

  return PersonalSummaryUIModel(
    selectedYear: selectedYear,
    selectedMonth: selectedMonth,
    availableYears: availableYears,
    yearTotal: yearTotal,
    periodTotal: periodTotal,
    categorySegments: categorySegments,
    monthlyRows: monthlyRows,
    recurringSplit: recurringSplit,
    givtVsExternalSplit: givtVsExternalSplit,
    givingGoal: givingGoal,
    goalProgress: goalProgress,
    hasDonationsInYear: yearTotal > 0,
  );
}

int _compareCategorySegments(ChartSegment a, ChartSegment b) {
  if (a.hasData != b.hasData) {
    return a.hasData ? -1 : 1;
  }
  if (a.hasData) {
    final byAmount = b.amount.compareTo(a.amount);
    if (byAmount != 0) {
      return byAmount;
    }
  }
  return a.category.name.compareTo(b.category.name);
}

/// Donut and legend order: descending by amount, then alphabetical for ties/zeros.
/// Monthly bar stacks keep a fixed Figma order in the widget layer.
List<ChartSegment> _buildCategorySegments(
  Map<GivingCategory, double> totals,
  double yearTotal,
) {
  final segments = GivingCategoryX.ordered.map((category) {
    final amount = totals[category] ?? 0;
    final fraction = yearTotal > 0 ? amount / yearTotal : 0.0;
    return ChartSegment(
      category: category,
      amount: amount,
      fraction: fraction,
    );
  }).toList()..sort(_compareCategorySegments);
  return segments;
}

List<MonthlyCategoryRow> _buildMonthlyRows(
  Map<int, Map<GivingCategory, double>> monthlyTotals,
) {
  return List.generate(12, (index) {
    final month = index + 1;
    final amounts = monthlyTotals[month]!;
    final total = amounts.values.fold<double>(0, (sum, value) => sum + value);
    return MonthlyCategoryRow(
      month: month,
      amountsByCategory: Map.unmodifiable(amounts),
      total: total,
    );
  });
}

SplitBarData _buildSplit(double primary, double secondary) {
  final total = primary + secondary;
  if (total <= 0) {
    return const SplitBarData.empty();
  }
  return SplitBarData(
    primaryAmount: primary,
    secondaryAmount: secondary,
    primaryFraction: primary / total,
    secondaryFraction: secondary / total,
  );
}
