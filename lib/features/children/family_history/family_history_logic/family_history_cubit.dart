import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/family_history/family_history_logic/family_history_repository.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';

part 'family_history_state.dart';

class FamilyHistoryCubit extends Cubit<FamilyHistoryState> {
  FamilyHistoryCubit(this.historyRepo) : super(const FamilyHistoryState());
  final FamilyHistoryRepository historyRepo;

  FutureOr<void> fetchHistory() async {
    emit(state.copyWith(status: HistroryStatus.loading));

    try {
      List<HistoryItem> history = [];
      history.addAll(state.history);
      // fetch donations
      final donationHistory = await historyRepo.fetchHistory(
          pageNumber: state.pageNr, type: HistoryTypes.donation);
      history.addAll(donationHistory);
      // fetch allowances
      final allowanceHistory = await historyRepo.fetchHistory(
          pageNumber: state.pageNr, type: HistoryTypes.allowance);
      history.addAll(allowanceHistory);
      // sort from newest to oldest
      history.sort((a, b) => b.date.compareTo(a.date));
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
