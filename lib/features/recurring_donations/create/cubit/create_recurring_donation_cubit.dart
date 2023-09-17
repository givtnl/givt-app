import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/features/recurring_donations/create/repositories/create_recurring_donation_repository.dart';
import 'package:givt_app/shared/models/collect_group.dart';

part 'create_recurring_donation_state.dart';

class CreateRecurringDonationCubit extends Cubit<CreateRecurringDonationState> {
  CreateRecurringDonationCubit(
    this._createRecurringDonationRepository,
  ) : super(
          CreateRecurringDonationState(
            startDate: DateTime.now().add(
              const Duration(days: 1),
            ),
            endDate: DateTime.now().add(
              const Duration(days: 2),
            ),
          ),
        );

  final CreateRecurringDonationRepository _createRecurringDonationRepository;

  void setRecipient(CollectGroup recipient) {
    emit(state.copyWith(recipient: recipient));
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void setTurns(int turns, {bool calculateEndDate = true}) {
    emit(state.copyWith(turns: turns));
    if (calculateEndDate) {
      _calculateAndInsertEndDate();
    }
  }

  void setStartDate(DateTime startDate) {
    if (startDate.isAfter(state.endDate)) {
      emit(state.copyWith(endDate: startDate, startDate: startDate));
      _calculateAndInsertTimesToStop();
      return;
    }
    emit(state.copyWith(startDate: startDate));
    _calculateAndInsertTimesToStop();
  }

  void setEndDate(DateTime endDate) {
    emit(state.copyWith(endDate: endDate));
    _calculateAndInsertTimesToStop();
  }

  void setFrequency(RecurringDonationFrequency frequency) {
    final currentTime = DateTime.now();
    emit(
      state.copyWith(
        frequency: frequency,
        turns: 1,
        startDate: currentTime.add(
          const Duration(days: 1),
        ),
        endDate: currentTime.add(
          const Duration(days: 2),
        ),
      ),
    );
  }

  Future<void> submit({
    required String guid,
    required String country,
    required double lowerLimit,
    required int maxLimit,
  }) async {
    emit(state.copyWith(status: CreateRecurringDonationStatus.loading));

    if (state.amount < lowerLimit) {
      emit(state.copyWith(status: CreateRecurringDonationStatus.amountTooLow));
      return;
    }

    if (state.amount > maxLimit) {
      emit(
        state.copyWith(status: CreateRecurringDonationStatus.amountTooHigh),
      );
      return;
    }

    try {
      final recurringDonation = RecurringDonation(
        amountPerTurn: state.amount,
        startDate: state.startDate,
        frequency: state.frequency.index,
        endsAfterTurns: state.turns,
        userId: guid,
        namespace: state.recipient.nameSpace,
        country: country,
      );
      final isSuccess = await _createRecurringDonationRepository
          .createRecurringDonation(recurringDonation);
      if (!isSuccess) {
        emit(state.copyWith(status: CreateRecurringDonationStatus.error));
        return;
      }
      emit(state.copyWith(status: CreateRecurringDonationStatus.success));
    } on SocketException {
      emit(state.copyWith(status: CreateRecurringDonationStatus.notInternet));
    } catch (e, stackTrace) {
      await LoggingInfo.instance.warning(
        'Error while creating recurring donation, $e',
        methodName: stackTrace.toString(),
      );
      emit(state.copyWith(status: CreateRecurringDonationStatus.error));
    }
  }

  void _calculateAndInsertTimesToStop() {
    var counter = 0;
    var tempDate = state.startDate;

    switch (state.frequency) {
      case RecurringDonationFrequency.week:
        while (tempDate.isBefore(state.endDate)) {
          tempDate = tempDate.copyWith(day: tempDate.day + 7);
          counter++;
        }
      case RecurringDonationFrequency.month:
        while (tempDate.isBefore(state.endDate)) {
          tempDate = tempDate.copyWith(month: tempDate.month + 1);
          counter++;
        }
      case RecurringDonationFrequency.quarter:
        while (tempDate.isBefore(state.endDate)) {
          tempDate = tempDate.copyWith(month: tempDate.month + 3);
          counter++;
        }
      case RecurringDonationFrequency.halfYear:
        while (tempDate.isBefore(state.endDate)) {
          tempDate = tempDate.copyWith(month: tempDate.month + 6);
          counter++;
        }
      case RecurringDonationFrequency.year:
        while (tempDate.isBefore(state.endDate)) {
          tempDate = tempDate.copyWith(year: tempDate.year + 1);
          counter++;
        }
    }

    setTurns(counter, calculateEndDate: false);
  }

  void _calculateAndInsertEndDate() {
    var counter = 1;
    var tempDate = state.endDate;

    switch (state.frequency) {
      case RecurringDonationFrequency.week:
        while (counter < state.turns) {
          tempDate = tempDate.copyWith(day: tempDate.day + 7);
          counter++;
        }
      case (RecurringDonationFrequency.month):
        while (counter < state.turns) {
          tempDate = tempDate.copyWith(month: tempDate.month + 1);
          counter++;
        }
      case RecurringDonationFrequency.quarter:
        while (counter < state.turns) {
          tempDate = tempDate.copyWith(month: tempDate.month + 3);
          counter++;
        }
      case RecurringDonationFrequency.halfYear:
        while (counter < state.turns) {
          tempDate = tempDate.copyWith(month: tempDate.month + 6);
          counter++;
        }
      case RecurringDonationFrequency.year:
        while (counter < state.turns) {
          tempDate = tempDate.copyWith(year: tempDate.year + 1);
          counter++;
        }
    }

    setEndDate(tempDate);
  }
}
