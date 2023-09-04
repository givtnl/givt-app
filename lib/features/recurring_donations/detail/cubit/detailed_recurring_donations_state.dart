part of 'detailed_recurring_donations_cubit.dart';

sealed class DetailedRecurringDonationsState extends Equatable {
  const DetailedRecurringDonationsState();

  @override
  List<Object> get props => [];
}

final class DetailedRecurringDonationsInitial
    extends DetailedRecurringDonationsState {}

final class DetailedRecurringDonationsLoading
    extends DetailedRecurringDonationsState {}

final class DetailedRecurringDonationsEmpty
    extends DetailedRecurringDonationsState {}

class DetailedInstancesFetched extends DetailedRecurringDonationsState {
  const DetailedInstancesFetched({
    required this.instances,
  });

  final List<RecurringDonationDetail> instances;
  @override
  List<Object> get props => [instances];
}

class DetailedRecurringDonationsError extends DetailedRecurringDonationsState {
  const DetailedRecurringDonationsError({
    required this.error,
  });

  final String error;
  @override
  List<Object> get props => [error];
}
