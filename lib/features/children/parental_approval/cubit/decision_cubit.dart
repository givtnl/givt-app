import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/parental_approval/models/decision_response.dart';
import 'package:givt_app/features/children/parental_approval/repositories/transaction_decision_repository.dart';

part 'decision_state.dart';

class DecisionCubit extends Cubit<DecisionState> {
  DecisionCubit(this.decisionRepository) : super(const DecisionState.initial());

  final TransactionDecisionRepository decisionRepository;

  Future<void> submitDecision({
    required ChildDonation donation,
    required DonationState decision,
  }) async {
    emit(state.copyWith(status: DecisionStatus.loading));

    try {
      final response = await decisionRepository.submitDecision(
        donationId: donation.id,
        childId: donation.userId,
        approved: decision == DonationState.approved,
      );

      emit(
        state.copyWith(
          status: DecisionStatus.made,
          response: response,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DecisionStatus.error,
        ),
      );
    }
  }
}
