import 'package:givt_app/features/recurring_donations/create/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart' as overview;
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/confirm_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

enum ConfirmAction {
  navigateToOrganization,
  navigateToAmount,
  navigateToFrequency,
  navigateToStartDate,
  navigateToEndDate,
  navigateToSuccess,
  showErrorBottomSheet,
  navigateToRecurringDonationsHome,
}

class Step4ConfirmCubit extends CommonCubit<ConfirmUIModel, ConfirmAction> {
  Step4ConfirmCubit(this._repository) : super(const BaseState.loading());

  final RecurringDonationRepository _repository;
  bool _isLoading = false;

  void init() {
    _emitData();
  }

  Future<void> createRecurringDonation() async {
    if (_isLoading) return;
    
    _isLoading = true;
    emitLoading();

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
        amount: double.parse(current.amount),
        frequency: frequency,
        startDate: current.startDate ?? DateTime.now(),
        namespace: _repository.selectedOrganization?.nameSpace ?? '',
        endDate: current.selectedEndOption == RecurringDonationStringKeys.onSpecificDate 
            ? current.endDate 
            : null,
        maxRecurrencies: turns == 999 ? null : turns,
      );

      final success = await _repository.createRecurringDonation(
        recurringDonation,
      );

      if (success) {
        _isLoading = false;
        emitCustom(ConfirmAction.navigateToSuccess);
      } else {
        _isLoading = false;
        _emitData();
        emitCustom(ConfirmAction.showErrorBottomSheet);
      }
    } on Exception catch (_) {
      _isLoading = false;
      _emitData();
      emitCustom(ConfirmAction.showErrorBottomSheet);
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

  int _calculateTurns(
    String selectedEndOption,
    String numberOfDonations,
    DateTime? startDate,
    DateTime? endDate,
    overview.Frequency frequency,
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
          case overview.Frequency.weekly:
            tempDate = tempDate.add(const Duration(days: 7));
          case overview.Frequency.monthly:
            tempDate = tempDate.copyWith(month: tempDate.month + 1);
          case overview.Frequency.quarterly:
            tempDate = tempDate.copyWith(month: tempDate.month + 3);
          case overview.Frequency.halfYearly:
            tempDate = tempDate.copyWith(month: tempDate.month + 6);
          case overview.Frequency.yearly:
            tempDate = tempDate.copyWith(year: tempDate.year + 1);
          case overview.Frequency.daily:
            tempDate = tempDate.add(const Duration(days: 1));
          case overview.Frequency.none:
            break;
        }
        counter++;
      }

      return counter;
    }

    throw Exception('Invalid end option: $selectedEndOption');
  }

  void _emitData() {
    emitData(
      getCurrent().copyWith(
        isLoading: _isLoading,
      ),
    );
  }
}
