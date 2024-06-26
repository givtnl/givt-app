import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/history/history_repository/history_repository.dart';
import 'package:givt_app/features/family/features/history/models/history_item.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.historyRepo) : super(const HistoryState());
  final HistoryRepository historyRepo;

  FutureOr<void> fetchHistory(
    String childId, {
    bool fromBeginning = false,
  }) async {
    // Make sure that it's not loading already
    if (state.status == HistoryStatus.loading) return;
    emit(state.copyWith(status: HistoryStatus.loading));

    if (fromBeginning) emit(state.copyWith(history: [], pageNr: 1));

    try {
      final donationHistoryFuture = historyRepo.fetchHistory(
        childId: childId,
        pageNumber: state.pageNr,
        type: HistoryTypes.donation,
      );

      final allowanceHistoryFuture = historyRepo.fetchHistory(
        childId: childId,
        pageNumber: state.pageNr,
        type: HistoryTypes.allowance,
      );

      // In this way the second future will already start fetching
      // while waiting for the first one to finish
      // This will make the fetching faster
      final donationHistory = await donationHistoryFuture;
      final allowanceHistory = await allowanceHistoryFuture;

      final history = <HistoryItem>[
        ...state.history,
        ...donationHistory,
        ...allowanceHistory,
      ]
        // sort from newest to oldest
        ..sort((a, b) => b.date.compareTo(a.date));

      // check if they reached end of history
      // if end of history do not increment page nr
      if (donationHistory.isEmpty && allowanceHistory.isEmpty) {
        emit(state.copyWith(status: HistoryStatus.loaded, history: history));
        return;
      }

      // update state
      emit(
        state.copyWith(
          status: HistoryStatus.loaded,
          history: history,
          pageNr: state.pageNr + 1,
        ),
      );
    } catch (e, stackTrace) {
      unawaited(
        LoggingInfo.instance.error(
          'Error while fetching history: $e',
          methodName: stackTrace.toString(),
        ),
      );

      emit(state.copyWith(status: HistoryStatus.error, error: e.toString()));
    }
  }
}
