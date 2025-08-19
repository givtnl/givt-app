import 'package:givt_app/features/recurring_donations/create/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/confirm_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

enum ConfirmAction {
  navigateToOrganization,
  navigateToAmount,
  navigateToFrequency,
  navigateToStartDate,
  navigateToEndDate,
  navigateToSuccess,
}

class Step4ConfirmCubit extends CommonCubit<ConfirmUIModel, ConfirmAction> {
  Step4ConfirmCubit(this._repository) : super(const BaseState.loading());

  final RecurringDonationNewFlowRepository _repository;
  bool _isLoading = false;

  void init() {
    _emitData();
  }

  void createRecurringDonation() async {
    if (_isLoading) return;

    _isLoading = true;
    _emitData(isLoading: true);

    try {
      final current = getCurrent();
      final frequency = current.frequency;

      if (frequency == null) {
        throw Exception('Frequency is required');
      }

      final turns = _calculateTurns(
        current.selectedEndOption,
        current.numberOfDonations,
        current.startDate,
        current.endDate,
        frequency,
      );

      final recurringDonation = RecurringDonation(
        userId: _repository.guid ?? '',
        frequency: _convertFrequencyToInt(frequency),
        startDate: current.startDate ?? DateTime.now(),
        amountPerTurn: double.parse(current.amount),
        namespace: _repository.selectedOrganization!.nameSpace,
        endsAfterTurns: turns,
        country: _repository.country ?? '',
      );

      final success = await _repository.createRecurringDonation(
        recurringDonation,
      );

      if (success) {
        _isLoading = false;
        _emitData(isLoading: false);
        emitCustom(ConfirmAction.navigateToSuccess);
      } else {
        _isLoading = false;
        _emitData(
          isLoading: false,
          error: 'Failed to create recurring donation',
        );
      }
    } catch (e) {
      _isLoading = false;
      _emitData(
        isLoading: false,
        error: 'An error occurred while creating the recurring donation',
      );
    }
  }

  void navigateToOrganization() {
    emitCustom(ConfirmAction.navigateToOrganization);
  }

  void navigateToAmount() {
    emitCustom(ConfirmAction.navigateToAmount);
  }

  void navigateToFrequency() {
    emitCustom(ConfirmAction.navigateToFrequency);
  }

  void navigateToStartDate() {
    emitCustom(ConfirmAction.navigateToStartDate);
  }

  void navigateToEndDate() {
    emitCustom(ConfirmAction.navigateToEndDate);
  }

  ConfirmUIModel getCurrent() {
    final model = ConfirmUIModel(
      organizationName: _repository.selectedOrganization?.orgName ?? '',
      amount: _repository.amount ?? '',
      frequency: _repository.frequency,
      startDate: _repository.startDate,
      endDate: _repository.endDate,
      numberOfDonations: _repository.numberOfDonations ?? '',
      selectedEndOption: _repository.selectedEndOption ?? '',
    );

    return model;
  }

  int _convertFrequencyToInt(RecurringDonationFrequency frequency) {
    switch (frequency) {
      case RecurringDonationFrequency.week:
        return 0;
      case RecurringDonationFrequency.month:
        return 1;
      case RecurringDonationFrequency.quarter:
        return 2;
      case RecurringDonationFrequency.halfYear:
        return 3;
      case RecurringDonationFrequency.year:
        return 4;
    }
  }

  int _calculateTurns(
    String selectedEndOption,
    String numberOfDonations,
    DateTime? startDate,
    DateTime? endDate,
    RecurringDonationFrequency frequency,
  ) {
    if (selectedEndOption == RecurringDonationStringKeys.whenIDecide) {
      return 999; // 999 means no end date
    } else if (selectedEndOption ==
        RecurringDonationStringKeys.afterNumberOfDonations) {
      return int.parse(numberOfDonations);
    } else if (selectedEndOption ==
            RecurringDonationStringKeys.onSpecificDate &&
        endDate != null) {
      var counter = 0;
      var tempDate = startDate!;

      while (tempDate.isBefore(endDate)) {
        switch (frequency) {
          case RecurringDonationFrequency.week:
            tempDate = tempDate.copyWith(day: tempDate.day + 7);
          case RecurringDonationFrequency.month:
            tempDate = tempDate.copyWith(month: tempDate.month + 1);
          case RecurringDonationFrequency.quarter:
            tempDate = tempDate.copyWith(month: tempDate.month + 3);
          case RecurringDonationFrequency.halfYear:
            tempDate = tempDate.copyWith(month: tempDate.month + 6);
          case RecurringDonationFrequency.year:
            tempDate = tempDate.copyWith(year: tempDate.year + 1);
        }
        counter++;
      }

      return counter;
    }

    throw Exception('Invalid end option: $selectedEndOption');
  }

  void _emitData({
    bool? isLoading,
    String? error,
  }) {
    emitData(
      getCurrent().copyWith(
        isLoading: isLoading ?? false,
        error: error,
      ),
    );
  }
}
