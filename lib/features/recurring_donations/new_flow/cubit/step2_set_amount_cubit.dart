import 'package:equatable/equatable.dart';
import 'package:givt_app/features/recurring_donations/new_flow/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SetAmountUIModel extends Equatable {
  const SetAmountUIModel({
    this.selectedFrequency,
    this.amount = '',
    this.isLoading = false,
    this.error,
  });

  final String? selectedFrequency;
  final String amount;
  final bool isLoading;
  final String? error;

  bool get isContinueEnabled =>
      (selectedFrequency != null && selectedFrequency!.isNotEmpty) &&
      amount.isNotEmpty &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0;

  SetAmountUIModel copyWith({
    String? selectedFrequency,
    String? amount,
    bool? isLoading,
    String? error,
  }) {
    return SetAmountUIModel(
      selectedFrequency: selectedFrequency ?? this.selectedFrequency,
      amount: amount ?? this.amount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [selectedFrequency, amount, isLoading, error];
}

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

  void selectFrequency(String frequency) {
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

  void _emitData({String? selectedFrequency, String? amount}) {
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
