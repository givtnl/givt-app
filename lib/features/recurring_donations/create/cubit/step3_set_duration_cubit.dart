import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/set_duration_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

enum SetDurationAction {
  navigateToConfirm,
}

class Step3SetDurationCubit
    extends CommonCubit<SetDurationUIModel, SetDurationAction> {
  Step3SetDurationCubit(this.repository) : super(const BaseState.loading());

  final RecurringDonationNewFlowRepository repository;

  void init() {
    emitLoading();

    // Default selectedOption to 'When I decide' if not set
    repository.selectedEndOption ??= RecurringDonationStringKeys.whenIDecide;

    final frequency = repository.frequency;
    var frequencyData = <String, dynamic>{};
    if (frequency != null) {
      final now = repository.startDate ?? DateTime.now();
      final day = now.day;
      final month = _monthName(now.month);
      frequencyData = {
        'frequency': frequency,
        'day': day,
        'month': month,
        'messageKey': _getFrequencyMessage(frequency, day, month),
      };
    }

    if (repository.startDate == null) {
      final now = DateTime.now();
      repository.startDate = now;
      _emitData(
        startDate: now,
        selectedOption: repository.selectedEndOption,
        numberOfDonations: repository.numberOfDonations ?? '',
        endDate: repository.endDate,
        frequencyData: frequencyData,
      );
    } else {
      _emitData(
        startDate: repository.startDate,
        selectedOption: repository.selectedEndOption,
        numberOfDonations: repository.numberOfDonations ?? '',
        endDate: repository.endDate,
        frequencyData: frequencyData,
      );
    }
  }

  void updateStartDate(DateTime date) {
    repository.startDate = date;
    _emitData(startDate: date);
  }

  void updateEndDate(DateTime date) {
    repository.endDate = date;
    _emitData(endDate: date);
  }

  void updateNumberOfDonations(String number) {
    repository.numberOfDonations = number;
    _emitData(numberOfDonations: number);
  }

  void updateSelectedOption(String option) {
    repository.selectedEndOption = option;
    _emitData(selectedOption: option);
  }

  void continueToNextStep() {
    if (repository.startDate != null &&
        (repository.endDate != null ||
            repository.numberOfDonations != null ||
            repository.selectedEndOption ==
                RecurringDonationStringKeys.whenIDecide)) {
      emitCustom(SetDurationAction.navigateToConfirm);
    }
  }

  void _emitData({
    DateTime? startDate,
    DateTime? endDate,
    String? numberOfDonations,
    String? selectedOption,
    Map<String, dynamic>? frequencyData,
  }) {
    SetDurationUIModel? currentData;
    if (state is DataState<SetDurationUIModel, SetDurationAction>) {
      currentData =
          (state as DataState<SetDurationUIModel, SetDurationAction>).data;
    }

    final isContinueEnabled = _calculateIsContinueEnabled(
      selectedOption ?? currentData?.selectedOption,
      numberOfDonations ?? currentData?.numberOfDonations ?? '',
      endDate ?? currentData?.endDate,
    );

    emitData(
      SetDurationUIModel(
        startDate: startDate ?? currentData?.startDate,
        endDate: endDate ?? currentData?.endDate,
        numberOfDonations:
            numberOfDonations ?? currentData?.numberOfDonations ?? '',
        selectedOption: selectedOption ?? currentData?.selectedOption,
        isContinueEnabled: isContinueEnabled,
        frequencyData: frequencyData ?? currentData?.frequencyData ?? const {},
      ),
    );
  }

  bool _calculateIsContinueEnabled(
    String? selectedOption,
    String numberOfDonations,
    DateTime? endDate,
  ) {
    if (selectedOption == null) return false;

    switch (selectedOption) {
      case RecurringDonationStringKeys.whenIDecide:
        return true;
      case RecurringDonationStringKeys.afterNumberOfDonations:
        return int.tryParse(numberOfDonations) != null &&
            int.parse(numberOfDonations) > 0;
      case RecurringDonationStringKeys.onSpecificDate:
        return endDate != null;
      default:
        return false;
    }
  }

  String _getFrequencyMessage(RecurringDonationFrequency frequency, int day, String month) {
    switch (frequency) {
      case RecurringDonationFrequency.week:
        return 'recurringDonationsEndDateHintEveryWeek';
      case RecurringDonationFrequency.month:
        return 'recurringDonationsEndDateHintEveryMonth';
      case RecurringDonationFrequency.quarter:
        return 'recurringDonationsEndDateHintEveryXMonth';
      case RecurringDonationFrequency.halfYear:
        return 'recurringDonationsEndDateHintEveryXMonth';
      case RecurringDonationFrequency.year:
        return 'recurringDonationsEndDateHintEveryYear';
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
