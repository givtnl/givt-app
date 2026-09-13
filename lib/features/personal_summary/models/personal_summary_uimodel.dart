import 'package:equatable/equatable.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/shared/models/giving_goal.dart';

class PersonalSummaryUIModel extends Equatable {
  const PersonalSummaryUIModel({
    required this.selectedYear,
    required this.availableYears,
    required this.yearTotal,
    required this.periodTotal,
    required this.categorySegments,
    required this.monthlyRows,
    required this.recurringSplit,
    required this.givtVsExternalSplit,
    required this.givingGoal,
    required this.goalProgress,
    required this.hasDonationsInYear,
    this.selectedMonth,
  });

  final int selectedYear;

  /// 1–12 when a month chip is selected; otherwise the full year.
  final int? selectedMonth;
  final List<int> availableYears;

  /// Full-year total, used by the giving-goal card.
  final double yearTotal;

  /// Total for the visible period (selected month, or the full year).
  final double periodTotal;
  final List<ChartSegment> categorySegments;
  final List<MonthlyCategoryRow> monthlyRows;
  final SplitBarData recurringSplit;
  final SplitBarData givtVsExternalSplit;
  final GivingGoal givingGoal;
  final double goalProgress;
  final bool hasDonationsInYear;

  bool get hasGivingGoal => givingGoal.hasGoal;
  bool get isCurrentYear => selectedYear == DateTime.now().year;
  bool get hasMonthFilter => selectedMonth != null;
  bool get showMonthlyChart => selectedMonth == null;

  bool get canGoToNextYear {
    if (availableYears.isEmpty) return false;
    return selectedYear < availableYears.first;
  }

  bool get canGoToPreviousYear {
    if (availableYears.isEmpty) return false;
    return selectedYear > availableYears.last;
  }

  bool get hasCategoryData =>
      categorySegments.any((segment) => segment.hasData);

  @override
  List<Object?> get props => [
    selectedYear,
    selectedMonth,
    availableYears,
    yearTotal,
    periodTotal,
    categorySegments,
    monthlyRows,
    recurringSplit,
    givtVsExternalSplit,
    givingGoal,
    goalProgress,
    hasDonationsInYear,
  ];
}
