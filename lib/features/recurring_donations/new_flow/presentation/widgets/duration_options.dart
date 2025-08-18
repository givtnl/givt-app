import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_date_picker.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_radio.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/new_flow/presentation/models/set_duration_ui_model.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

class DurationOptions extends StatelessWidget {
  const DurationOptions({
    required this.selectedOption,
    required this.onOptionSelected,
    required this.uiModel,
    required this.onNumberChanged,
    required this.onDateChanged,
    required this.frequency,
    super.key,
  });

  static const List<String> _optionKeys = [
    RecurringDonationStringKeys.whenIDecide,
    RecurringDonationStringKeys.afterNumberOfDonations,
    RecurringDonationStringKeys.onSpecificDate,
  ];

  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;
  final SetDurationUIModel uiModel;
  final ValueChanged<String> onNumberChanged;
  final ValueChanged<DateTime> onDateChanged;
  final String? frequency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelMediumText(context.l10n.recurringDonationsEndsTitle),
        const SizedBox(height: 8),
        ..._optionKeys.map((optionKey) {
          final isSelected = selectedOption == optionKey;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FunInputRadio(
                label: _translateOption(context, optionKey),
                isSelected: isSelected,
                onTap: () => _handleOptionTap(context, optionKey, isSelected),
              ),
              if (optionKey ==
                      RecurringDonationStringKeys.afterNumberOfDonations &&
                  isSelected)
                _buildNumberInput(context),
              if (optionKey == RecurringDonationStringKeys.onSpecificDate &&
                  isSelected)
                _buildDatePicker(context),
            ],
          );
        }),
      ],
    );
  }

  void _handleOptionTap(
    BuildContext context,
    String optionKey,
    bool isSelected,
  ) {
    onOptionSelected(optionKey);
    if (frequency == null) return;

    switch (optionKey) {
      case RecurringDonationStringKeys.whenIDecide:
        final day = _getDayWithOrdinal(uiModel.startDate ?? DateTime.now());
        FunSnackbar.show(
          context,
          message: context.l10n.recurringDonationsEndDateHintEveryMonth(
            day,
            day,
          ),
          icon: const Icon(
            Icons.calendar_today,
            color: Color(0xFF234B5E),
            size: 32,
          ),
        );
      case RecurringDonationStringKeys.afterNumberOfDonations:
        final numberOfDonations = int.tryParse(uiModel.numberOfDonations) ?? 1;
        final calculatedEndDate = _calculateEndDateFromNumberOfDonations(
          uiModel.startDate!,
          frequency!,
          numberOfDonations,
        );
        final message = _buildSnackbarMessage(
          frequency,
          uiModel.startDate!,
          calculatedEndDate,
        );
        FunSnackbar.show(
          context,
          message: message,
          icon: const Icon(
            Icons.calendar_today,
            color: Color(0xFF234B5E),
            size: 32,
          ),
        );
      case RecurringDonationStringKeys.onSpecificDate:
        final endDate = uiModel.endDate ?? DateTime.now();
        final message = _buildSnackbarMessage(
          frequency,
          uiModel.startDate!,
          endDate,
        );
        FunSnackbar.show(
          context,
          message: message,
          icon: const Icon(
            Icons.calendar_today,
            color: Color(0xFF234B5E),
            size: 32,
          ),
        );
    }
  }

  Widget _buildNumberInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: OutlinedTextFormField(
        hintText: 'Enter the number',
        initialValue: uiModel.numberOfDonations,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        onChanged: (number) {
          onNumberChanged(number);
          final n = number.isNotEmpty ? number : 'X';
          DateTime endDate;
          if (frequency != null && number.isNotEmpty) {
            final numberOfDonations = int.tryParse(number) ?? 1;
            endDate = _calculateEndDateFromNumberOfDonations(
              uiModel.startDate!,
              frequency!,
              numberOfDonations,
            );
            onDateChanged(endDate);
          } else {
            endDate = DateTime.now();
          }
          final day = endDate.day;
          final month = _monthName(endDate.month);
          final year = endDate.year;
          FunSnackbar.show(
            context,
            message: "You'll donate $n times, ending on $day $month $year",
            icon: const Icon(
              Icons.repeat,
              color: Color(0xFF234B5E),
              size: 32,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FunDatePicker(
        selectedDate: uiModel.endDate,
        onDateSelected: (date) {
          onDateChanged(date);
          final message = _buildSnackbarMessage(
            frequency,
            uiModel.startDate!,
            date,
          );
          FunSnackbar.show(
            context,
            message: message,
            icon: const Icon(
              Icons.calendar_today,
              color: Color(0xFF234B5E),
              size: 32,
            ),
          );
        },
      ),
    );
  }

  String _translateOption(BuildContext context, String optionKey) {
    switch (optionKey) {
      case RecurringDonationStringKeys.whenIDecide:
        return context.l10n.recurringDonationsEndsWhenIDecide;
      case RecurringDonationStringKeys.afterNumberOfDonations:
        return context.l10n.recurringDonationsEndsAfterNumber;
      case RecurringDonationStringKeys.onSpecificDate:
        return context.l10n.recurringDonationsEndsAfterDate;
    }

    return '';
  }
}

String _buildSnackbarMessage(
  String? frequency,
  DateTime startDate,
  DateTime endDate,
) {
  if (frequency == null) return '';

  // Calculate the amount of donations
  final int amountOfDonations;
  switch (frequency) {
    case 'Weekly':
      // Calculate weeks between dates, including partial weeks
      amountOfDonations = (startDate.difference(endDate).inDays.abs() ~/ 7) + 1;
    case 'Monthly':
      // Calculate months between dates, including partial months
      amountOfDonations =
          ((endDate.year - startDate.year) * 12) +
          endDate.month -
          startDate.month +
          1;
    case 'Quarterly':
      // Calculate quarters between dates, including partial quarters
      final months =
          ((endDate.year - startDate.year) * 12) +
          endDate.month -
          startDate.month;
      amountOfDonations = (months ~/ 3) + 1;
    case 'Half year':
      // Calculate half-years between dates, including partial half-years
      final months =
          ((endDate.year - startDate.year) * 12) +
          endDate.month -
          startDate.month;
      amountOfDonations = (months ~/ 6) + 1;
    case 'Yearly':
      // Calculate years between dates, including partial years
      amountOfDonations = (endDate.year - startDate.year) + 1;
    default:
      amountOfDonations = 0;
  }

  final formattedDate = DateFormat('dd MMM yyyy').format(endDate);
  return "You'll donate $amountOfDonations times, ending on $formattedDate";
}

DateTime _calculateEndDateFromNumberOfDonations(
  DateTime startDate,
  String frequency,
  int numberOfDonations,
) {
  switch (frequency) {
    case 'Weekly':
      return startDate.add(Duration(days: (numberOfDonations - 1) * 7));
    case 'Monthly':
      return DateTime(
        startDate.year + ((startDate.month + numberOfDonations - 1) ~/ 12),
        ((startDate.month + numberOfDonations - 1) % 12) + 1,
        startDate.day,
      );
    case 'Quarterly':
      return DateTime(
        startDate.year +
            ((startDate.month + (numberOfDonations - 1) * 3) ~/ 12),
        ((startDate.month + (numberOfDonations - 1) * 3) % 12) + 1,
        startDate.day,
      );
    case 'Half year':
      return DateTime(
        startDate.year +
            ((startDate.month + (numberOfDonations - 1) * 6) ~/ 12),
        ((startDate.month + (numberOfDonations - 1) * 6) % 12) + 1,
        startDate.day,
      );
    case 'Yearly':
      return DateTime(
        startDate.year + numberOfDonations - 1,
        startDate.month,
        startDate.day,
      );
    default:
      return startDate;
  }
}

String _monthName(int month) {
  if (month < 1 || month > 12) return '';

  // Use localized month names from the current locale
  final now = DateTime.now();
  final date = DateTime(now.year, month, 1);
  return DateFormat('MMM').format(date);
}

String _getDayWithOrdinal(DateTime date) {
  // Use localized ordinal formatting from the current locale
  final now = date.toMoment();
  return now.format('Do');
}
