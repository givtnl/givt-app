import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/give/cubit/give_result_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

typedef GiveResultClock = DateTime Function();
typedef GiveResultSleeper = Future<void> Function(Duration duration);

/// Polls a submitted donation's status after the confirm browser closes.
class GiveResultCubit extends CommonCubit<GiveResultUIModel, dynamic> {
  GiveResultCubit(
    this._givtRepository, {
    this.pollInterval = const Duration(seconds: 1),
    this.timeout = const Duration(seconds: 10),
    GiveResultClock? clock,
    GiveResultSleeper? sleeper,
  }) : _clock = clock ?? DateTime.now,
       _sleeper = sleeper ?? Future<void>.delayed,
       super(const BaseState.initial());

  final GivtRepository _givtRepository;
  final Duration pollInterval;
  final Duration timeout;
  final GiveResultClock _clock;
  final GiveResultSleeper _sleeper;

  Future<void> checkStatus(List<int> transactionIds) async {
    emitLoading();

    if (transactionIds.isEmpty) {
      LoggingInfo.instance.warning(
        'No transaction ids available after confirm browser closed',
        methodName: 'GiveResultCubit.checkStatus',
      );
      _emitOutcome(GiveResultOutcome.unknown);
      return;
    }

    final transactionId = transactionIds.first;
    final deadline = _clock().add(timeout);

    while (true) {
      if (isClosed) {
        return;
      }
      try {
        final status = await _givtRepository.fetchTransactionStatus(
          transactionId,
        );
        LoggingInfo.instance.info(
          'Fetched transaction $transactionId status $status',
          methodName: 'GiveResultCubit.checkStatus',
        );
        _emitOutcome(GiveResultUIModel.fromLegacyStatus(status));
        return;
      } on Object catch (e) {
        LoggingInfo.instance.error(
          'Failed to fetch transaction $transactionId status: $e',
          methodName: 'GiveResultCubit.checkStatus',
        );
        if (!_clock().isBefore(deadline)) {
          break;
        }
        await _sleeper(pollInterval);
      }
    }

    _emitOutcome(GiveResultOutcome.unknown);
  }

  void _emitOutcome(GiveResultOutcome outcome) {
    if (isClosed) {
      return;
    }
    emitData(GiveResultUIModel(outcome: outcome));
  }
}
