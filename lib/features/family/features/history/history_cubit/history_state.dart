part of 'history_cubit.dart';

enum HistroryStatus { initial, loading, loaded, error }

class HistoryState extends Equatable {
  const HistoryState(
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

  HistoryState copyWith({
    HistroryStatus? status,
    List<HistoryItem>? history,
    int? pageNr,
    String? error,
  }) {
    return HistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      pageNr: pageNr ?? this.pageNr,
      error: error ?? this.error,
    );
  }
}
