part of 'pledge_manage_cubit.dart';

class PledgeManageUIModel {
  const PledgeManageUIModel({
    required this.detail,
    this.isSaving = false,
  });

  final PledgeDetailUIModel detail;
  final bool isSaving;

  PledgeGroup get group => detail.group;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PledgeManageUIModel &&
        other.detail == detail &&
        other.isSaving == isSaving;
  }

  @override
  int get hashCode => Object.hash(detail, isSaving);
}

sealed class PledgeManageCustom {
  const PledgeManageCustom();

  const factory PledgeManageCustom.showAmountEditor({
    required PledgeGoal goal,
  }) = ShowAmountEditor;

  const factory PledgeManageCustom.showFrequencyEditor() = ShowFrequencyEditor;

  const factory PledgeManageCustom.showGivingMethodEditor() =
      ShowGivingMethodEditor;

  const factory PledgeManageCustom.manageUpdateSucceeded() =
      ManageUpdateSucceeded;

  const factory PledgeManageCustom.manageUpdateFailed() = ManageUpdateFailed;
}

class ShowAmountEditor extends PledgeManageCustom {
  const ShowAmountEditor({required this.goal});

  final PledgeGoal goal;
}

class ShowFrequencyEditor extends PledgeManageCustom {
  const ShowFrequencyEditor();
}

class ShowGivingMethodEditor extends PledgeManageCustom {
  const ShowGivingMethodEditor();
}

class ManageUpdateSucceeded extends PledgeManageCustom {
  const ManageUpdateSucceeded();
}

class ManageUpdateFailed extends PledgeManageCustom {
  const ManageUpdateFailed();
}
