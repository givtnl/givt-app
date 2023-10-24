part of 'yearly_overview_cubit.dart';

enum YearlyOverviewStatus { initial, loading, loaded, error }

final class YearlyOverviewState extends Equatable {
  const YearlyOverviewState({
    required this.year,
    this.externalDonations = const [],
    this.monthlyByOrganisation = const [],
    this.externalDonationsPreviousYear = const [],
    this.monthlyByOrganisationPreviousYear = const [],
    this.externalDonationsPerMonth = const [],
    this.monthlyByOrganisationPerMonth = const [],
    this.status = YearlyOverviewStatus.initial,
    this.givingGoal = 0.0,
  });

  final YearlyOverviewStatus status;
  final List<SummaryItem> externalDonations;
  final List<SummaryItem> monthlyByOrganisation;
  final List<SummaryItem> externalDonationsPreviousYear;
  final List<SummaryItem> monthlyByOrganisationPreviousYear;
  final List<SummaryItem> externalDonationsPerMonth;
  final List<SummaryItem> monthlyByOrganisationPerMonth;
  final String year;
  final double givingGoal;

  double get totalWithinGivt => monthlyByOrganisation
      .map((e) => e.amount)
      .fold(0, (previousValue, element) => previousValue + element);

  double get totalOutsideGivt => externalDonations
      .map((e) => e.amount)
      .fold(0, (previousValue, element) => previousValue + element);

  double get totalTaxRelief {
    final totalTaxReliefOutsideGivt = externalDonations
        .where((element) => element.taxDeductable == true)
        .map((e) => e.amount)
        .fold(0.0, (previousValue, element) => previousValue + element);

    final totalTaxReliefWithinGivt = monthlyByOrganisation
        .where((element) => element.taxDeductable == true)
        .map((e) => e.amount)
        .fold(0.0, (previousValue, element) => previousValue + element);

    return totalTaxReliefOutsideGivt + totalTaxReliefWithinGivt;
  }

  List<SummaryItem> get monthlyTotalSummaryMergedList {
    final mergedList = <SummaryItem>[];
    for (final it in monthlyByOrganisationPerMonth) {
      mergedList.add(
        SummaryItem(
          key: it.key,
          amount: it.amount,
          count: it.count,
          taxDeductable: it.taxDeductable,
        ),
      );
    }

    for (var it in mergedList) {
      final matchingNotViaGivt = externalDonationsPerMonth.firstWhere(
        (x) => x.key == it.key,
        orElse: SummaryItem.empty,
      );
      if (matchingNotViaGivt.key.isNotEmpty) {
        it = it.copyWith(
          amount: it.amount + matchingNotViaGivt.amount,
        );
      }
    }

    for (final it in externalDonationsPerMonth) {
      if (mergedList
          .firstWhere(
            (x) => x.key == it.key,
            orElse: SummaryItem.empty,
          )
          .key
          .isEmpty) {
        mergedList.add(it);
      }
    }

    return mergedList;
  }

  YearlyOverviewState copyWith({
    YearlyOverviewStatus? status,
    List<SummaryItem>? externalDonations,
    List<SummaryItem>? monthlyByOrganisation,
    List<SummaryItem>? externalDonationsPreviousYear,
    List<SummaryItem>? monthlyByOrganisationPreviousYear,
    List<SummaryItem>? externalDonationsPerMonth,
    List<SummaryItem>? monthlyByOrganisationPerMonth,
    String? year,
    double? givingGoal,
  }) {
    return YearlyOverviewState(
      status: status ?? this.status,
      externalDonations: externalDonations ?? this.externalDonations,
      externalDonationsPerMonth:
          externalDonationsPerMonth ?? this.externalDonationsPerMonth,
      monthlyByOrganisationPerMonth:
          monthlyByOrganisationPerMonth ?? this.monthlyByOrganisationPerMonth,
      monthlyByOrganisation:
          monthlyByOrganisation ?? this.monthlyByOrganisation,
      externalDonationsPreviousYear:
          externalDonationsPreviousYear ?? this.externalDonationsPreviousYear,
      monthlyByOrganisationPreviousYear: monthlyByOrganisationPreviousYear ??
          this.monthlyByOrganisationPreviousYear,
      year: year ?? this.year,
      givingGoal: givingGoal ?? this.givingGoal,
    );
  }

  @override
  List<Object> get props => [
        externalDonations,
        monthlyByOrganisation,
        externalDonationsPreviousYear,
        monthlyByOrganisationPreviousYear,
        externalDonationsPerMonth,
        monthlyByOrganisationPerMonth,
        year,
        status,
        givingGoal,
      ];
}
