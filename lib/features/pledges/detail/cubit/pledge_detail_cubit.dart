import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/pledges/detail/models/pledge_history_item.dart';
import 'package:givt_app/features/pledges/detail/pledge_detail_history_builder.dart';
import 'package:givt_app/features/pledges/detail/repositories/pledge_detail_repository.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'pledge_detail_state.dart';

class PledgeDetailCubit extends CommonCubit<PledgeDetailUIModel, dynamic> {
  PledgeDetailCubit(this._repository) : super(const BaseState.loading());

  final PledgeDetailRepository _repository;

  Future<void> init(String pledgeGroupId) async {
    emitLoading();
    try {
      await _repository.loadDetail(pledgeGroupId);
      if (isClosed) return;

      if (_repository.getError() != null || _repository.getPledgeGroup() == null) {
        emitError(null);
        return;
      }

      emitData(_createUIModel(_repository.getPledgeGroup()!));
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load pledge detail: $error',
        methodName: 'PledgeDetailCubit.init',
      );
      if (isClosed) return;
      emitError(null);
    }
  }

  PledgeDetailUIModel _createUIModel(PledgeGroup group) {
    final history = PledgeDetailHistoryBuilder.build(
      group: group,
      now: DateTime.now(),
    );

    return PledgeDetailUIModel(
      group: group,
      givenSoFar: group.givenSoFar,
      totalPledged: group.totalPledged,
      recurringTotal: group.goals.fold<double>(
        0,
        (sum, goal) => sum + goal.amount,
      ),
      recurringFrequency: _resolveRecurringFrequency(group.goals),
      goalProgress: group.goals
          .map(
            (goal) => PledgeGoalProgress(
              goal: goal,
              given: goal.displayGivenAmount,
              target: goal.pledgeTargetAmount,
            ),
          )
          .toList(),
      history: history,
    );
  }

  /// Shared frequency when all goals match; otherwise first goal's frequency.
  String? _resolveRecurringFrequency(List<PledgeGoal> goals) {
    if (goals.isEmpty) {
      return null;
    }
    final first = goals.first.frequency;
    final allSame = goals.every((goal) => goal.frequency == first);
    return allSame ? first : goals.first.frequency;
  }
}
