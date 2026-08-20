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

PersonalSummaryUIModel buildPersonalSummaryUIModel({
  required List<Givt> allGivts,
  required List<ExternalDonation> allExternalDonations,
  required List<CollectGroup> collectGroups,
  required GivingGoal givingGoal,
  required int selectedYear,
}) {
  final availableYears = deriveAvailableYears(
    givts: allGivts,
    externalDonations: allExternalDonations,
  );

  final yearGivts = givtsForYear(allGivts, selectedYear);
  final yearExternal =
      externalDonationsForYear(allExternalDonations, selectedYear);

  final categoryTotals = {
    for (final category in GivingCategoryX.ordered) category: 0.0,
  };

  var givtTotal = 0.0;
  var externalTotal = 0.0;
  var recurringTotal = 0.0;
  var oneOffTotal = 0.0;

  final monthlyTotals = {
    for (var month = 1; month <= 12; month++)
      month: {
        for (final category in GivingCategoryX.ordered) category: 0.0,
      },
  };

  for (final givt in yearGivts) {
    final amount = givt.amount;
    final category = categoryForGivt(givt, collectGroups);
    categoryTotals[category] = categoryTotals[category]! + amount;
    givtTotal += amount;

    if (givt.donationType == 1) {
      recurringTotal += amount;
    } else {
      oneOffTotal += amount;
    }

    final month = givt.timeStamp?.month;
    if (month != null) {
      monthlyTotals[month]![category] =
          monthlyTotals[month]![category]! + amount;
    }
  }

  for (final donation in yearExternal) {
    final amount = donation.amount;
    categoryTotals[GivingCategory.other] =
        categoryTotals[GivingCategory.other]! + amount;
    externalTotal += amount;

    if (donation.isRecurring) {
      recurringTotal += amount;
    } else {
      oneOffTotal += amount;
    }

    final month = donationDateForExternal(donation)?.month;
    if (month != null) {
      monthlyTotals[month]![GivingCategory.other] =
          monthlyTotals[month]![GivingCategory.other]! + amount;
    }
  }

  final yearTotal = givtTotal + externalTotal;
  final categorySegments = _buildCategorySegments(categoryTotals, yearTotal);
  final monthlyRows = _buildMonthlyRows(monthlyTotals);
  final recurringSplit = _buildSplit(recurringTotal, oneOffTotal);
  final givtVsExternalSplit = _buildSplit(givtTotal, externalTotal);

  final goalAmount = givingGoal.yearlyGivingGoal;
  final goalProgress = goalAmount > 0 ? (yearTotal / goalAmount).clamp(0.0, 1.0) : 0.0;

  return PersonalSummaryUIModel(
    selectedYear: selectedYear,
    availableYears: availableYears,
    yearTotal: yearTotal,
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
  }).toList()
    ..sort(_compareCategorySegments);
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
