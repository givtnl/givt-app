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
    this.monthlyGivts = const [],
    this.pastTwelveMonths = const [],
    this.externalDonations = const [],
    this.annualGivts = const [],
  });
  final PersonalSummaryStatus status;
  final UserExt loggedInUserExt;
  final String error;
  final String dateTime;
  final List<SummaryItem> monthlyGivts;
  final List<SummaryItem> annualGivts;
  final List<SummaryItem> pastTwelveMonths;
  final List<ExternalDonation> externalDonations;

  double get totalSumPerMonth =>
      monthlyGivts.fold<double>(0, (sum, item) => sum + item.amount) +
      externalDonations.fold<double>(0, (sum, item) => sum + item.amount);

  PersonalSummaryState copyWith({
    PersonalSummaryStatus? status,
    UserExt? loggedInUserExt,
    String? error,
    String? dateTime,
    List<SummaryItem>? monthlyGivts,
    List<SummaryItem>? annualGivts,
    List<SummaryItem>? pastTwelveMonths,
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
      ];
}
