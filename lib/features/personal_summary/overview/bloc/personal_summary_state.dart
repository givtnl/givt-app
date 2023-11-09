part of 'personal_summary_bloc.dart';

enum PersonalSummaryStatus {
  initial,
  loading,
  success,
  error,
  noInternet,
}

class PersonalSummaryState extends Equatable {
  const PersonalSummaryState({
    this.dateTime = '',
    this.status = PersonalSummaryStatus.initial,
    this.loggedInUserExt = const UserExt.empty(),
    this.error = '',
    this.givingGoal = const GivingGoal.empty(),
    this.monthlyGivts = const [],
    this.pastTwelveMonths = const [],
    this.externalDonations = const [],
    this.annualGivts = const [],
    this.externalDonationsAllTime = const [],
  });
  final PersonalSummaryStatus status;
  final UserExt loggedInUserExt;
  final String error;
  final String dateTime;
  final GivingGoal givingGoal;
  final List<SummaryItem> monthlyGivts;
  final List<SummaryItem> annualGivts;
  final List<SummaryItem> pastTwelveMonths;
  final List<ExternalDonation> externalDonations;
  final List<ExternalDonation> externalDonationsAllTime;

  double get totalSumPerMonth =>
      monthlyGivts.fold<double>(0, (sum, item) => sum + item.amount) +
      externalDonations.fold<double>(0, (sum, item) => sum + item.amount);

  double get averageGiven => totalSumPerMonth / monthlyGivts.length;

  double get maxInPastTwelveMonths {
    final maxPastTwelveMonthsCalc = pastTwelveMonths.fold<double>(
        0, (max, item) => max < item.amount ? item.amount : max);
    if (givingGoal.amount > 0) {
      return maxPastTwelveMonthsCalc > givingGoal.yearlyGivingGoal / 12
          ? maxPastTwelveMonthsCalc
          : givingGoal.yearlyGivingGoal / 12;
    }

    return maxPastTwelveMonthsCalc;
  }

  double externalDonationsYearSum(int year) {
    return externalDonationsAllTime
        .where((element) => DateTime.parse(element.creationDate).year == year)
        .fold<double>(0, (sum, item) => sum + item.amount);
  }

  PersonalSummaryState copyWith({
    PersonalSummaryStatus? status,
    UserExt? loggedInUserExt,
    String? error,
    String? dateTime,
    GivingGoal? givingGoal,
    List<SummaryItem>? monthlyGivts,
    List<SummaryItem>? annualGivts,
    List<SummaryItem>? pastTwelveMonths,
    List<ExternalDonation>? externalDonationsAllTime,
    List<ExternalDonation>? externalDonations,
  }) {
    return PersonalSummaryState(
      status: status ?? this.status,
      loggedInUserExt: loggedInUserExt ?? this.loggedInUserExt,
      error: error ?? this.error,
      dateTime: dateTime ?? this.dateTime,
      monthlyGivts: monthlyGivts ?? this.monthlyGivts,
      annualGivts: annualGivts ?? this.annualGivts,
      pastTwelveMonths: pastTwelveMonths ?? this.pastTwelveMonths,
      externalDonations: externalDonations ?? this.externalDonations,
      givingGoal: givingGoal ?? this.givingGoal,
      externalDonationsAllTime:
          externalDonationsAllTime ?? this.externalDonationsAllTime,
    );
  }

  @override
  List<Object> get props => [
        status,
        loggedInUserExt,
        error,
        dateTime,
        monthlyGivts,
        annualGivts,
        pastTwelveMonths,
        externalDonations,
        externalDonationsAllTime,
        givingGoal,
      ];
}
