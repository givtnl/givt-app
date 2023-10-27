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
      final tempHistory = <HistoryItem>[];
      final pendingHistory = <HistoryItem>[];
      final history = <HistoryItem>[];

      // sort previous history into pending
      if (state.history.isNotEmpty) {
        final previousDonation = state.history
            .where((element) => element.type == HistoryTypes.donation)
            .cast<ChildDonation>()
            .toList();
        pendingHistory.addAll(
          previousDonation
              .where((element) => element.state == DonationState.pending)
              .toList(),
        );
        tempHistory
          ..addAll(
            previousDonation
                .where((element) => element.state != DonationState.pending)
                .toList(),
          )
          ..addAll(
            state.history
                .where((element) => element.type == HistoryTypes.allowance)
                .toList(),
          );
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
      tempHistory.addAll(
        donationHistory.where((element) {
          final e = element as ChildDonation;
          return e.state != DonationState.pending;
        }),
      );
      // fetch allowances
      final allowanceHistory = await historyRepo.fetchHistory(
          pageNumber: state.pageNr, type: HistoryTypes.allowance);
      tempHistory.addAll(allowanceHistory);

      // sort from newest to oldest
      pendingHistory.sort((a, b) => b.date.compareTo(a.date));
      tempHistory.sort((a, b) => b.date.compareTo(a.date));

      // add pending donations first then all history chronologically
      history
        ..addAll(pendingHistory)
        ..addAll(tempHistory);

      // check if they reached end of history
      // if end of history do not increment page nr
      if (donationHistory.isEmpty && allowanceHistory.isEmpty) {
        emit(state.copyWith(status: HistroryStatus.loaded, history: history));
        return;
      }
      // update state
      emit(state.copyWith(
          status: HistroryStatus.loaded,
          history: history,
          pageNr: state.pageNr + 1));
    } catch (e) {
      emit(state.copyWith(status: HistroryStatus.error, error: e.toString()));
    }
  }
}
