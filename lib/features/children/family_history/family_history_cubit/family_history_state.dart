part of 'family_history_cubit.dart';

enum HistroryStatus { initial, loading, loaded, error }

class FamilyHistoryState extends Equatable {
  const FamilyHistoryState(
      {this.status = HistroryStatus.initial,
      this.history = const [],
      this.pageNr = 1,
      this.error = ''});

  final HistroryStatus status;
  final List<HistoryItem> history;
  final int pageNr;
  final String error;

  @override
  List<Object> get props => [status, history, pageNr, error];

  FamilyHistoryState copyWith({
    HistroryStatus? status,
    List<HistoryItem>? history,
    int? pageNr,
    String? error,
  }) {
    return FamilyHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      pageNr: pageNr ?? this.pageNr,
      error: error ?? this.error,
    );
  }
}
