import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_external_donation_state.dart';

class AddExternalDonationCubit extends Cubit<AddExternalDonationState> {
  AddExternalDonationCubit() : super(const AddExternalDonationState());
}
