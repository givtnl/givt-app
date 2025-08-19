import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/set_amount_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

enum SetAmountAction {
  navigateToDuration,
}

class Step2SetAmountCubit
    extends CommonCubit<SetAmountUIModel, SetAmountAction> {
  Step2SetAmountCubit(this._repository) : super(const BaseState.loading());

  final RecurringDonationNewFlowRepository _repository;

  void init() {
    _emitData(
      selectedFrequency: _repository.frequency,
      amount: _repository.amount,
    );
  }

  void selectFrequency(RecurringDonationFrequency frequency) {
    _repository.frequency = frequency;
    _emitData(selectedFrequency: frequency);
  }

  void enterAmount(String amount) {
    _repository.amount = amount;
    _emitData(amount: amount);
  }

  void continueToNextStep() {
    if (_repository.amount != null && _repository.frequency != null) {
      emitCustom(SetAmountAction.navigateToDuration);
    }
  }

  void _emitData({RecurringDonationFrequency? selectedFrequency, String? amount}) {
    SetAmountUIModel? currentData;
    if (state is DataState<SetAmountUIModel, SetAmountAction>) {
      currentData =
          (state as DataState<SetAmountUIModel, SetAmountAction>).data;
    }

    emitData(
      SetAmountUIModel(
        selectedFrequency: selectedFrequency ?? currentData?.selectedFrequency,
        amount: amount ?? currentData?.amount ?? '',
      ),
    );
  }
}
