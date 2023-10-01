import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/models.dart';

part 'add_external_donation_state.dart';

class AddExternalDonationCubit extends Cubit<AddExternalDonationState> {
  AddExternalDonationCubit() : super(const AddExternalDonationState());

  void init() {
   emit(state.copyWith(status: AddExternalDonationStatus.loading));
  }

  void addExternalDonation() {
    // todo
  }

  void removeExternalDonation() {
    // todo
  }

  void updateExternalDonation() {
    // todo
  }

  void save() {
    // todo
  }


}
