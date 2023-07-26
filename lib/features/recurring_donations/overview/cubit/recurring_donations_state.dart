part of 'recurring_donations_cubit.dart';

abstract class RecurringDonationsState extends Equatable {
  const RecurringDonationsState();

  @override
  List<Object> get props => [];
}

class RecurringDonationsInitialState extends RecurringDonationsState {}

class RecurringDonationsFetchingState extends RecurringDonationsState {}

class RecurringDonationsErrorState extends RecurringDonationsState {
  const RecurringDonationsErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

class RecurringDonationsFetchedState extends RecurringDonationsState {
  const RecurringDonationsFetchedState({required this.recurringDonations});

  final List<RecurringDonation> recurringDonations;

  List<RecurringDonation> get activeRecurringDonations {
    return recurringDonations
        .where(
          (element) =>
              element.currentState == RecurringDonationState.inProcess ||
              element.currentState == RecurringDonationState.processed,
        )
        .toList();
  }

  bool get isNoActiveReccuringDonations {
    return activeRecurringDonations.isEmpty;
  }

  @override
  List<Object> get props => [recurringDonations];
}
