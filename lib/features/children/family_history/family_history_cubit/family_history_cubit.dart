import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/family_history/models/child_donation.dart';
import 'package:givt_app/features/children/family_history/models/child_donation_helper.dart';
import 'package:givt_app/features/children/family_history/repository/family_history_repository.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';

part 'family_history_state.dart';

class FamilyHistoryCubit extends Cubit<FamilyHistoryState> {
  FamilyHistoryCubit(this.historyRepo) : super(const FamilyHistoryState());
  final FamilyDonationHistoryRepository historyRepo;

  FutureOr<void> fetchHistory() async {
    emit(state.copyWith(status: HistroryStatus.loading));

    try {
      final temporaryHistory = <HistoryItem>[];
      final arrangedHistory = <HistoryItem>[];
      final pendingHistory = <HistoryItem>[];
      final decidedHistory = <HistoryItem>[];

      if (state.history.isNotEmpty) {
        final previousDonation = <HistoryItem>[];
        final previousPending = <HistoryItem>[];
        previousDonation.addAll(state.history
            .where((element) => element.type == HistoryTypes.donation));
        previousPending.addAll(previousDonation.where((element) {
          final e = element as ChildDonation;
          return e.state == DonationState.pending;
        }));
        final previousDecided = state.history
            .where((element) => !previousPending.contains(element));
        temporaryHistory.addAll(previousDecided);
        pendingHistory.addAll(previousPending);
      }

      // fetch donations
      final donationHistory = await historyRepo.fetchHistory(
          pageNumber: state.pageNr, type: HistoryTypes.donation);

      pendingHistory.addAll(
        donationHistory.where((element) {
          final e = element as ChildDonation;
          return e.state == DonationState.pending;
        }),
      );
      decidedHistory.addAll(
        donationHistory.where((element) {
          final e = element as ChildDonation;
          return e.state != DonationState.pending;
        }),
      );
      temporaryHistory.addAll(decidedHistory);
      // fetch allowances
      final allowanceHistory = await historyRepo.fetchHistory(
          pageNumber: state.pageNr, type: HistoryTypes.allowance);
      temporaryHistory.addAll(allowanceHistory);
      // sort from newest to oldest
      pendingHistory.sort((a, b) => b.date.compareTo(a.date));
      temporaryHistory.sort((a, b) => b.date.compareTo(a.date));
      arrangedHistory
        ..addAll(pendingHistory)
        ..addAll(temporaryHistory);
      // check if they reached end of history
      // if end of history do not increment page nr
      if (donationHistory.isEmpty && allowanceHistory.isEmpty) {
        emit(state.copyWith(
            status: HistroryStatus.loaded, history: arrangedHistory));
        return;
      }
      // update state
      emit(state.copyWith(
          status: HistroryStatus.loaded,
          history: arrangedHistory,
          pageNr: state.pageNr + 1));
    } catch (e) {
      emit(state.copyWith(status: HistroryStatus.error, error: e.toString()));
    }
  }
}
