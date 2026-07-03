import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/pledges/detail/cubit/pledge_detail_cubit.dart';
import 'package:givt_app/features/pledges/detail/pledge_detail_history_builder.dart';
import 'package:givt_app/features/pledges/detail/repositories/pledge_detail_repository.dart';
import 'package:givt_app/features/pledges/manage/models/pledge_manage_field.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'pledge_manage_state.dart';

class PledgeManageCubit
    extends CommonCubit<PledgeManageUIModel, PledgeManageCustom> {
  PledgeManageCubit(this._repository) : super(const BaseState.loading());

  final PledgeDetailRepository _repository;

  PledgeManageUIModel? get currentUIModel {
    final group = _repository.getPledgeGroup();
    if (group == null) {
      return null;
    }
    return _createUIModel(group);
  }

  bool _isSaving = false;
  bool _hasUpdates = false;

  bool get hasUpdates => _hasUpdates;

  Future<void> init(String pledgeGroupId) async {
    emitLoading();
    try {
      await _repository.loadDetail(pledgeGroupId);
      if (isClosed) return;

      if (_repository.getError() != null ||
          _repository.getPledgeGroup() == null) {
        emitError(null);
        return;
      }

      emitData(_createUIModel(_repository.getPledgeGroup()!));
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load pledge manage screen: $error',
        methodName: 'PledgeManageCubit.init',
      );
      if (isClosed) return;
      emitError(null);
    }
  }

  void onManageFieldPressed({
    required PledgeManageField field,
    PledgeGoal? goal,
  }) {
    if (_isSaving) {
      return;
    }

    switch (field) {
      case PledgeManageField.goalAmount:
        if (goal == null) {
          return;
        }
        emitCustom(PledgeManageCustom.showAmountEditor(goal: goal));
      case PledgeManageField.frequency:
        emitCustom(const PledgeManageCustom.showFrequencyEditor());
      case PledgeManageField.givingMethod:
        emitCustom(const PledgeManageCustom.showGivingMethodEditor());
    }
    emitData(_createUIModel(_repository.getPledgeGroup()!));
  }

  Future<void> saveGoalAmount({
    required PledgeGoal goal,
    required double amount,
  }) async {
    await _saveUpdate(
      update: () => _repository.updatePledge(
        pledgeId: goal.id,
        amount: amount,
      ),
      methodName: 'PledgeManageCubit.saveGoalAmount',
    );
  }

  Future<void> saveFrequency({
    required String frequency,
  }) async {
    final group = _repository.getPledgeGroup();
    if (group == null) {
      return;
    }

    await _saveUpdate(
      update: () async {
        for (final goal in group.goals) {
          final success = await _repository.updatePledge(
            pledgeId: goal.id,
            frequency: frequency,
          );
          if (!success) {
            return false;
          }
        }
        return true;
      },
      methodName: 'PledgeManageCubit.saveFrequency',
    );
  }

  Future<void> saveGivingMethod({
    required String type,
  }) async {
    final group = _repository.getPledgeGroup();
    if (group == null) {
      return;
    }

    await _saveUpdate(
      update: () async {
        for (final goal in group.goals) {
          final success = await _repository.updatePledge(
            pledgeId: goal.id,
            type: type,
          );
          if (!success) {
            return false;
          }
        }
        return true;
      },
      methodName: 'PledgeManageCubit.saveGivingMethod',
    );
  }

  Future<void> _saveUpdate({
    required Future<bool> Function() update,
    required String methodName,
  }) async {
    if (_isSaving) {
      return;
    }

    final group = _repository.getPledgeGroup();
    if (group == null) {
      return;
    }

    _isSaving = true;
    emitData(_createUIModel(group));

    try {
      final success = await update();
      if (isClosed) return;

      if (!success) {
        await _repository.loadDetail(group.pledgeGroupId);
        if (isClosed) return;

        _isSaving = false;
        emitCustom(const PledgeManageCustom.manageUpdateFailed());
        final refreshedGroup = _repository.getPledgeGroup() ?? group;
        emitData(_createUIModel(refreshedGroup));
        return;
      }

      await _repository.loadDetail(group.pledgeGroupId);
      if (isClosed) return;

      final refreshedGroup = _repository.getPledgeGroup();
      if (refreshedGroup == null) {
        _isSaving = false;
        emitCustom(const PledgeManageCustom.manageUpdateFailed());
        emitData(_createUIModel(group));
        return;
      }

      _isSaving = false;
      _hasUpdates = true;
      emitCustom(const PledgeManageCustom.manageUpdateSucceeded());
      emitData(_createUIModel(refreshedGroup));
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to update pledge: $error',
        methodName: methodName,
      );
      if (isClosed) return;
      _isSaving = false;
      emitCustom(const PledgeManageCustom.manageUpdateFailed());
      final currentGroup = _repository.getPledgeGroup() ?? group;
      emitData(_createUIModel(currentGroup));
    }
  }

  PledgeManageUIModel _createUIModel(PledgeGroup group) {
    final detailModel = PledgeDetailUIModel(
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
      history: PledgeDetailHistoryBuilder.build(
        group: group,
        now: DateTime.now(),
      ),
    );

    return PledgeManageUIModel(
      detail: detailModel,
      isSaving: _isSaving,
    );
  }

  String? _resolveRecurringFrequency(List<PledgeGoal> goals) {
    if (goals.isEmpty) {
      return null;
    }
    final first = goals.first.frequency;
    final allSame = goals.every((goal) => goal.frequency == first);
    return allSame ? first : null;
  }
}
