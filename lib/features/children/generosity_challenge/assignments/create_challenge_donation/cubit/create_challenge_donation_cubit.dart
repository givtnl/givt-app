import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_challenge_donation_state.dart';

class CreateChallengeDonationCubit extends Cubit<CreateChallengeDonationState> {
  CreateChallengeDonationCubit()
      : super(const CreateChallengeDonationState(amount: 0));

  void updateAmount(double amount) => emit(state.copyWith(amount: amount));
}
