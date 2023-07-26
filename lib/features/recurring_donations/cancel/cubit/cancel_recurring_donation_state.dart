part of 'cancel_recurring_donation_cubit.dart';

abstract class CancelRecurringDonationState extends Equatable {
  const CancelRecurringDonationState();

  @override
  List<Object> get props => [];
}

class CancelRecurringDonationConfirmationState
    extends CancelRecurringDonationState {}

class CancelRecurringDonationCancellingState
    extends CancelRecurringDonationState {}

class CancelRecurringDonationSuccessState
    extends CancelRecurringDonationState {}

class CancelRecurringDonationErrorState extends CancelRecurringDonationState {
  const CancelRecurringDonationErrorState({
    required this.error,
  });

  final String error;

  @override
  List<Object> get props => [error];
}
