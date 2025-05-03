import 'package:equatable/equatable.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/new_flow/repository/recurring_donation_new_flow_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class SetDurationUIModel extends Equatable {
  const SetDurationUIModel({
    this.startDate,
    this.selectedOption,
    this.numberOfDonations = '',
    this.endDate,
    this.isLoading = false,
    this.error,
    this.isContinueEnabled = false,
    this.frequencyMessage = '',
  });

  final DateTime? startDate;
  final String? selectedOption;
  final String numberOfDonations;
  final DateTime? endDate;
  final bool isLoading;
  final String? error;
  final bool isContinueEnabled;
  final String frequencyMessage;

  Map<String, dynamic> get analyticsParams => {
        'startDate': startDate?.toIso8601String() ?? '',
        'selectedOption': selectedOption ?? '',
        'numberOfDonations': numberOfDonations,
        'endDate': endDate?.toIso8601String() ?? '',
      };

  SetDurationUIModel copyWith({
    DateTime? startDate,
    String? selectedOption,
    String? numberOfDonations,
    DateTime? endDate,
    bool? isLoading,
    String? error,
    bool? isContinueEnabled,
    String? frequencyMessage,
  }) {
    return SetDurationUIModel(
      startDate: startDate ?? this.startDate,
      selectedOption: selectedOption ?? this.selectedOption,
      numberOfDonations: numberOfDonations ?? this.numberOfDonations,
      endDate: endDate ?? this.endDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isContinueEnabled: isContinueEnabled ?? this.isContinueEnabled,
      frequencyMessage: frequencyMessage ?? this.frequencyMessage,
    );
  }

  @override
  List<Object?> get props => [
        startDate,
        selectedOption,
        numberOfDonations,
        endDate,
        isLoading,
        error,
        isContinueEnabled,
        frequencyMessage
      ];
}

enum SetDurationAction {
  navigateToConfirm,
}

class Step3SetDurationCubit
    extends CommonCubit<SetDurationUIModel, SetDurationAction> {
  Step3SetDurationCubit(this.repository) : super(const BaseState.loading());

  final RecurringDonationNewFlowRepository repository;

  void onInit() {
    emitLoading();

    // Default selectedOption to 'When I decide' if not set
    repository.selectedEndOption ??= RecurringDonationStringKeys.whenIDecide;

    final frequency = repository.frequency;
    String frequencyMessage = '';
    if (frequency != null) {
      final now = repository.startDate ?? DateTime.now();
      final day = now.day;
      final month = _monthName(now.month);
      frequencyMessage = _getFrequencyMessage(frequency, day, month);
    }

    if (repository.startDate == null) {
      final now = DateTime.now();
      repository.startDate = now;
      _emitData(
        startDate: now,
        selectedOption: repository.selectedEndOption,
        numberOfDonations: repository.numberOfDonations ?? '',
        endDate: repository.endDate,
        frequencyMessage: frequencyMessage,
      );
    } else {
      _emitData(
        startDate: repository.startDate,
        selectedOption: repository.selectedEndOption,
        numberOfDonations: repository.numberOfDonations ?? '',
        endDate: repository.endDate,
        frequencyMessage: frequencyMessage,
      );
    }
  }

  void updateStartDate(DateTime date) {
    _emitData(startDate: date);
  }

  void updateEndDate(DateTime date) {
    _emitData(endDate: date);
  }

  void updateNumberOfDonations(String number) {
    _emitData(numberOfDonations: number);
  }

  void updateSelectedOption(String option) {
    _emitData(selectedOption: option);
  }

  void continueToNextStep() {
    if (repository.startDate != null &&
        (repository.endDate != null ||
            repository.numberOfDonations != null ||
            repository.selectedEndOption == 'When I decide')) {
      emitCustom(SetDurationAction.navigateToConfirm);
    }
  }

  void _emitData({
    DateTime? startDate,
    DateTime? endDate,
    String? numberOfDonations,
    String? selectedOption,
    String? frequencyMessage,
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
        frequencyMessage:
            frequencyMessage ?? currentData?.frequencyMessage ?? '',
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

  String _getFrequencyMessage(String frequency, int day, String month) {
    switch (frequency) {
      case 'Weekly':
        return 'Your donation will occur every week on the $day';
      case 'Monthly':
        return 'Your donation will occur on the $day of every month';
      case 'Quarterly':
        return 'Your donation will occur every 3 months on the $day';
      case 'Half year':
        return 'Your donation will occur every 6 months on the $day';
      case 'Yearly':
        return 'Your donation will occur once a year on the $day of $month';
      default:
        return '';
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
