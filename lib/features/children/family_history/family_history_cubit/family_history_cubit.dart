import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/children/family_history/models/history_item.dart';
import 'package:givt_app/features/children/family_history/repository/family_history_repository.dart';
import 'package:givt_app/features/children/parental_approval/models/parental_approval_response.dart';
import 'package:givt_app/features/children/parental_approval/repositories/parental_approval_repository.dart';
import 'package:givt_app/features/family/features/giving_flow/create_transaction/repositories/create_transaction_repository.dart';

part 'family_history_state.dart';

class FamilyHistoryCubit extends Cubit<FamilyHistoryState> {
  FamilyHistoryCubit(
    this.historyRepo,
    this._editChildRepository,
    this._parentalApprovalRepository,
    this._createTransactionRepository,
  ) : super(const FamilyHistoryState()) {
    _init();
  }

  final FamilyDonationHistoryRepository historyRepo;
  final EditChildRepository _editChildRepository;
  final ParentalApprovalRepository _parentalApprovalRepository;
  final CreateTransactionRepository _createTransactionRepository;

  StreamSubscription<String>? _walletChangedSubscription;
  StreamSubscription<String>? _userTransactionSubscription;
  StreamSubscription<ParentalApprovalResponse>? _approvalSubscription;


  void _init() {
    _walletChangedSubscription =
        _editChildRepository.childChangedStream().listen((childGUID) {
      fetchHistory(fromScratch: true);
    });

    _approvalSubscription = _parentalApprovalRepository
        .onParentalApprovalChanged()
        .listen((response) {
      fetchHistory(fromScratch: true);
    });

    _userTransactionSubscription = _createTransactionRepository
        .onTransactionByUser()
        .listen((_) {
      fetchHistory(fromScratch: true);
    });
  }

  @override
  Future<void> close() async {
    await _approvalSubscription?.cancel();
    await _walletChangedSubscription?.cancel();
    await _userTransactionSubscription?.cancel();
    await super.close();
  }

  Future<void> fetchHistory({bool fromScratch = false}) async {
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
          await historyRepo.getHistory(pageNumber: state.pageNr);

      resultHistory.addAll(newPageHistory.where((item) => !resultHistory
          .any((existing) => existing.type == item.type && existing == item)));

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

  Future<void> refresh() async => fetchHistory(fromScratch: true);
}
