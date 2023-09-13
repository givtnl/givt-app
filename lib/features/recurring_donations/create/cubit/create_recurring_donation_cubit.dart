import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/collect_group.dart';

part 'create_recurring_donation_state.dart';

class CreateRecurringDonationCubit extends Cubit<CreateRecurringDonationState> {
  CreateRecurringDonationCubit() : super(const CreateRecurringDonationState());

  void setRecipient(CollectGroup recipient) {
    emit(state.copyWith(recipient: recipient));
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void setTurns(int turns) {
    emit(state.copyWith(turns: turns));
  }

  void setStartDate(DateTime startDate) {
    emit(state.copyWith(startDate: startDate));
  }

  void setEndDate(DateTime endDate) {
    emit(state.copyWith(endDate: endDate));
  }

  void reset() {
    emit(const CreateRecurringDonationState());
  }

  bool get isEnabled {
    return state.recipient.orgName.isNotEmpty &&
        state.amount > 0 &&
        state.turns > 0 &&
        state.startDate != null &&
        state.endDate != null;
  }

  void submit() {
    emit(state.copyWith(status: CreateRecurringDonationStatus.loading));
    //todo save recurring donation
    try {
      
    } catch (e) {
      emit(state.copyWith(status: CreateRecurringDonationStatus.error));
    }
  }
}
