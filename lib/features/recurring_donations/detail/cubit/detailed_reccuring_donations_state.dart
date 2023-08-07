part of 'detailed_reccuring_donations_cubit.dart';

sealed class DetailedReccuringDonationsState extends Equatable {
  const DetailedReccuringDonationsState();

  @override
  List<Object> get props => [];
}

final class DetailedReccuringDonationsInitial
    extends DetailedReccuringDonationsState {}

final class DetailedReccuringDonationsLoading
    extends DetailedReccuringDonationsState {}

class DetailedInstancesFetched extends DetailedReccuringDonationsState {
  const DetailedInstancesFetched({
    required this.instances,
  });

  final List<RecurringDonationDetail> instances;
  @override
  List<Object> get props => [instances];
}

class DetailedReccuringDonationsError extends DetailedReccuringDonationsState {
  const DetailedReccuringDonationsError({
    required this.error,
  });

  final String error;
  @override
  List<Object> get props => [error];
}
