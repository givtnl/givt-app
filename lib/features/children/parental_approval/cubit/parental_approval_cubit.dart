import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/parental_approval/repositories/parental_approval_repository.dart';
import 'package:givt_app/utils/utils.dart';

part 'parental_approval_state.dart';

class ParentalApprovalCubit extends Cubit<ParentalApprovalState> {
  ParentalApprovalCubit({
    required this.donation,
    required this.decisionRepository,
  }) : super(
          ParentalApprovalState(
            donation: donation,
            status: DecisionStatus.confirmation,
          ),
        );

  static const _approvalResultDelay = Duration(seconds: 3);

  final ParentalApprovalRepository decisionRepository;
  final ChildDonation donation;

  Future<void> _emitDelayedPopWithDecision(bool decisionMade) async {
    // ignore: inference_failure_on_instance_creation
    await Future.delayed(_approvalResultDelay);
    if (isClosed) return;
    emit(
      state.copyWith(
        status: DecisionStatus.pop,
        decisionMade: decisionMade,
      ),
    );
  }

  Future<void> submitDecision({
    required DonationState decision,
  }) async {
    emit(state.copyWith(status: DecisionStatus.loading));

    try {
      final response = await decisionRepository.submitDecision(
        donationId: donation.id,
        childId: donation.userId,
        approved: decision == DonationState.approved,
      );

      if (response.isError) {
        throw Error();
      }

      emit(
        state.copyWith(
          status: decision == DonationState.approved
              ? DecisionStatus.approved
              : DecisionStatus.declined,
        ),
      );

      await AnalyticsHelper.logEvent(
        eventName: decision == DonationState.approved
            ? AmplitudeEvents.pendingDonationApproved
            : AmplitudeEvents.pendingDonationDeclined,
        eventProperties: {
          'child_name': donation.name,
          'charity_name': donation.organizationName,
          'date': donation.date,
          'amount': donation.amount,
        },
      );

      await _emitDelayedPopWithDecision(true);
    } catch (e) {
      emit(state.copyWith(status: DecisionStatus.error));
      await _emitDelayedPopWithDecision(false);
    }
  }
}
