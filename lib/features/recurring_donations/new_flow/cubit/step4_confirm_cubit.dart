import 'dart:io';

import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/recurring_donations/new_flow/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/new_flow/models/recurring_donation_frequency.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/models/confirm_ui_model.dart';
import 'package:givt_app/features/recurring_donations/new_flow/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

enum ConfirmAction {
  navigateToOrganization,
  navigateToAmount,
  navigateToFrequency,
  navigateToStartDate,
  navigateToEndDate,
  donationConfirmed,
}

class Step4ConfirmCubit extends CommonCubit<ConfirmUIModel, ConfirmAction> {
  Step4ConfirmCubit(
    this._repository,
  ) : super(const BaseState.data(ConfirmUIModel()));

  final RecurringDonationNewFlowRepository _repository;
  bool _isLoading = false;

  void init() {
    final model = ConfirmUIModel(
      organizationName: _repository.selectedOrganization?.orgName ?? '',
      amount: _repository.amount ?? '',
      frequency: _repository.frequency ?? '',
      startDate: _repository.startDate,
      endDate: _repository.endDate,
      numberOfDonations: _repository.numberOfDonations ?? '',
      selectedEndOption: _repository.selectedEndOption ?? '',
    );
    emitData(model);
  }

  Future<void> confirmDonation(String country) async {
    _isLoading = true;
    var current = getCurrent();
    emitData(current);

    try {
      // Convert frequency string to enum
      final frequency = _convertFrequencyToEnum(current.frequency);

      // Calculate number of turns based on end option
      final turns = _calculateTurns(
        current.selectedEndOption,
        current.numberOfDonations,
        current.startDate,
        current.endDate,
        frequency,
      );

      // Create recurring donation model
      final recurringDonation = RecurringDonation(
        amountPerTurn: double.parse(current.amount),
        startDate: current.startDate!,
        frequency: frequency.index,
        endsAfterTurns: turns,
        userId: _repository.guid!,
        namespace: _repository.selectedOrganization!.nameSpace,
        country: country,
      );

      // Submit to backend
      final isSuccess =
          await _repository.createRecurringDonation(recurringDonation);

      if (!isSuccess) {
        _isLoading = false;
        current = current.copyWith(
          isLoading: false,
          error: 'Failed to create recurring donation',
        );

        emitData(current);
        return;
      }

      _isLoading = false;
      emitData(current.copyWith(isLoading: false));
      emitCustom(ConfirmAction.donationConfirmed);
    } on SocketException {
      _isLoading = false;
      emitData(current.copyWith(
        isLoading: false,
        error: 'No internet connection',
      ));
    } catch (e, stackTrace) {
      if (e is GivtServerFailure) {
        if (e.statusCode == 409) {
          _isLoading = false;
          emitData(current.copyWith(
            isLoading: false,
            error: 'A recurring donation already exists for this organization',
          ));
          return;
        }
      }
      LoggingInfo.instance.warning(
        'Error while creating recurring donation, $e',
        methodName: stackTrace.toString(),
      );
      _isLoading = false;
      emitData(current.copyWith(
        isLoading: false,
        error: 'An error occurred while creating the recurring donation',
      ));
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
      frequency: _repository.frequency ?? '',
      startDate: _repository.startDate,
      endDate: _repository.endDate,
      numberOfDonations: _repository.numberOfDonations ?? '',
      selectedEndOption: _repository.selectedEndOption ?? '',
    );

    return model;
  }

  RecurringDonationFrequency _convertFrequencyToEnum(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'weekly':
        return RecurringDonationFrequency.week;
      case 'monthly':
        return RecurringDonationFrequency.month;
      case 'quarterly':
        return RecurringDonationFrequency.quarter;
      case 'half-yearly':
        return RecurringDonationFrequency.halfYear;
      case 'yearly':
        return RecurringDonationFrequency.year;
      default:
        throw Exception('Invalid frequency: $frequency');
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
    } else if (selectedEndOption == RecurringDonationStringKeys.onSpecificDate &&
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
}
