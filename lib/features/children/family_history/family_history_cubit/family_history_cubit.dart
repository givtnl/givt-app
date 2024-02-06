import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';
import 'package:givt_app/features/children/family_history/repository/family_history_repository.dart';

part 'family_history_state.dart';

class FamilyHistoryCubit extends Cubit<FamilyHistoryState> {
  FamilyHistoryCubit(this.historyRepo) : super(const FamilyHistoryState());
  final FamilyDonationHistoryRepository historyRepo;

  FutureOr<void> fetchHistory({bool fromScratch = false}) async {
    emit(
      state.copyWith(
        status: HistroryStatus.loading,
        history: fromScratch ? [] : null,
        pageNr: fromScratch ? 1 : null,
      ),
    );

    try {
      final resultHistory = <HistoryItem>[...state.history];

      final newPageHistory =
          await historyRepo.fetchHistory(pageNumber: state.pageNr);

      resultHistory.addAll(newPageHistory);

      emit(
        state.copyWith(
          status: HistroryStatus.loaded,
          history: resultHistory,
          pageNr: newPageHistory.isNotEmpty ? state.pageNr + 1 : null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HistroryStatus.error, error: e.toString()));
    }
  }
}
