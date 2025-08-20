import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_date_picker.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_radio.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/models/set_duration_ui_model.dart';
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
  final RecurringDonationFrequency? frequency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelMediumText.secondary40(context.l10n.recurringDonationsEndsTitle),
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
              const SizedBox(height: 4),
              Container(
                height: 1,
                color: FamilyAppTheme.neutralVariant95,
              ),
              const SizedBox(height: 4),
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
          context,
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
          context,
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
        hintText: context.l10n.recurringDonationsCreateDurationNumberHint,
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
          final formattedDate = DateFormat('dd MMMM yyyy').format(endDate);

          if (n == '1') {
            FunSnackbar.show(
              context,
              message: context.l10n
                  .recurringDonationsCreateDurationSnackbarOnce(formattedDate),
              icon: const Icon(
                Icons.repeat,
                color: Color(0xFF234B5E),
                size: 32,
              ),
            );
          } else {
            FunSnackbar.show(
              context,
              message: context.l10n
                  .recurringDonationsCreateDurationSnackbarTimes(
                    formattedDate,
                    n,
                  ),
              icon: const Icon(
                Icons.repeat,
                color: Color(0xFF234B5E),
                size: 32,
              ),
            );
          }
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
            context,
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
  BuildContext context,
  RecurringDonationFrequency? frequency,
  DateTime startDate,
  DateTime endDate,
) {
  final int amountOfDonations;
  switch (frequency) {
    case RecurringDonationFrequency.week:
      // Calculate weeks between dates, including partial weeks
      amountOfDonations = (startDate.difference(endDate).inDays.abs() ~/ 7) + 1;
    case RecurringDonationFrequency.month:
      // Calculate months between dates, including partial months
      amountOfDonations =
          (endDate.year - startDate.year) * 12 +
          endDate.month -
          startDate.month +
          1;
    case RecurringDonationFrequency.quarter:
      // Calculate quarters between dates, including partial quarters
      final months =
          (endDate.year - startDate.year) * 12 +
          endDate.month -
          startDate.month;
      amountOfDonations = (months ~/ 3) + 1;
    case RecurringDonationFrequency.halfYear:
      // Calculate half-years between dates, including partial half-years
      final months =
          (endDate.year - startDate.year) * 12 +
          endDate.month -
          startDate.month;
      amountOfDonations = (months ~/ 6) + 1;
    case RecurringDonationFrequency.year:
      // Calculate years between dates, including partial years
      amountOfDonations = (endDate.year - startDate.year) + 1;
    case null:
      amountOfDonations = 0;
  }

  final formattedDate = DateFormat('dd MMMM yyyy').format(endDate);

  if (amountOfDonations == 1) {
    return context.l10n.recurringDonationsCreateDurationSnackbarOnce(
      formattedDate,
    );
  }

  return context.l10n.recurringDonationsCreateDurationSnackbarMultiple(
    amountOfDonations,
    formattedDate,
  );
}

DateTime _calculateEndDateFromNumberOfDonations(
  DateTime startDate,
  RecurringDonationFrequency frequency,
  int numberOfDonations,
) {
  switch (frequency) {
    case RecurringDonationFrequency.week:
      return startDate.add(Duration(days: (numberOfDonations - 1) * 7));
    case RecurringDonationFrequency.month:
      return DateTime(
        startDate.year + ((startDate.month + numberOfDonations - 1) ~/ 12),
        ((startDate.month + numberOfDonations - 1) % 12) + 1,
        startDate.day,
      );
    case RecurringDonationFrequency.quarter:
      return DateTime(
        startDate.year +
            ((startDate.month + (numberOfDonations - 1) * 3 - 1) ~/ 12),
        ((startDate.month + (numberOfDonations - 1) * 3 - 1) % 12) + 1,
        startDate.day,
      );
    case RecurringDonationFrequency.halfYear:
      return DateTime(
        startDate.year +
            ((startDate.month + (numberOfDonations - 1) * 6 - 1) ~/ 12),
        ((startDate.month + (numberOfDonations - 1) * 6 - 1) % 12) + 1,
        startDate.day,
      );
    case RecurringDonationFrequency.year:
      return DateTime(
        startDate.year + numberOfDonations - 1,
        startDate.month,
        startDate.day,
      );
  }
}

String _monthName(int month) {
  if (month < 1 || month > 12) return '';

  // Use localized month names from the current locale
  final now = DateTime.now();
  final date = DateTime(now.year, month, 1);
  return DateFormat('MMMM').format(date);
}

String _getDayWithOrdinal(DateTime date) {
  // Use localized ordinal formatting from the current locale
  final now = date.toMoment();
  return now.format('Do');
}
