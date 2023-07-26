import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/recurring_donations/cancel/repositories/cancel_recurring_donation_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';

part 'cancel_recurring_donation_state.dart';

class CancelRecurringDonationCubit extends Cubit<CancelRecurringDonationState> {
  CancelRecurringDonationCubit(
    this._cancelRecurringDonationRepository,
  ) : super(CancelRecurringDonationConfirmationState());

  final CancelRecurringDonationRepository _cancelRecurringDonationRepository;

  Future<void> cancelRecurringDonations(
    RecurringDonation recurringDonation,
  ) async {
    emit(CancelRecurringDonationCancellingState());
    try {
      await _cancelRecurringDonationRepository.cancelRecurringDonation(
        recurringDonationId: recurringDonation.id,
      );
      emit(CancelRecurringDonationSuccessState());
    } catch (error) {
      emit(CancelRecurringDonationErrorState(error: error.toString()));
    }
  }
}
