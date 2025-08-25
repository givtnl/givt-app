import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

class DurationOptions extends StatefulWidget {
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
  State<DurationOptions> createState() => _DurationOptionsState();
}

class _DurationOptionsState extends State<DurationOptions> {
  Timer? _snackbarTimer;
  late KeyboardVisibilityController _keyboardVisibilityController;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _keyboardVisibilityController = KeyboardVisibilityController();
    
    // Listen to keyboard visibility changes
    _keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
      
      // If keyboard just became visible, close any existing snackbars
      if (visible) {
        FunSnackbar.removeCurrent();
        _snackbarTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _snackbarTimer?.cancel();
    super.dispose();
  }

  void _showSnackbarWithKeyboardCheck(
    BuildContext context,
    String message,
    Widget icon, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    // Cancel any existing timer
    _snackbarTimer?.cancel();
    
    // Don't show snackbar if keyboard is visible
    if (_isKeyboardVisible) {
      return;
    }

    _snackbarTimer = Timer(delay, () {
      if (!context.mounted) return;
      
      // Check keyboard visibility again before showing
      if (_isKeyboardVisible) return;
      
      FunSnackbar.show(context, message: message, icon: icon);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelMediumText.secondary40(context.l10n.recurringDonationsEndsTitle),
        const SizedBox(height: 8),
        ...DurationOptions._optionKeys.map((optionKey) {
          final isSelected = widget.selectedOption == optionKey;
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
    widget.onOptionSelected(optionKey);
    
    // Only show snackbar if frequency is available and start date is selected
    if (widget.frequency == null || widget.uiModel.startDate == null) return;

    // Add a small delay to ensure keyboard is closed and UI is stable
    Timer(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;
      
      switch (optionKey) {
        case RecurringDonationStringKeys.whenIDecide:
          final day = _getDayWithOrdinal(widget.uiModel.startDate!);
          _showSnackbarWithKeyboardCheck(
            context,
            context.l10n.recurringDonationsEndDateHintEveryMonth(
              day,
              day,
            ),
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF234B5E),
              size: 32,
            ),
          );
        case RecurringDonationStringKeys.afterNumberOfDonations:
          final numberOfDonations = int.tryParse(widget.uiModel.numberOfDonations) ?? 1;
          final calculatedEndDate = _calculateEndDateFromNumberOfDonations(
            widget.uiModel.startDate!,
            widget.frequency!,
            numberOfDonations,
          );
          final message = _buildSnackbarMessage(
            context,
            widget.frequency,
            widget.uiModel.startDate!,
            calculatedEndDate,
          );
          _showSnackbarWithKeyboardCheck(
            context,
            message,
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF234B5E),
              size: 32,
            ),
          );
        case RecurringDonationStringKeys.onSpecificDate:
          final endDate = widget.uiModel.endDate ?? DateTime.now();
          final message = _buildSnackbarMessage(
            context,
            widget.frequency,
            widget.uiModel.startDate!,
            endDate,
          );
          _showSnackbarWithKeyboardCheck(
            context,
            message,
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF234B5E),
              size: 32,
            ),
          );
      }
    });
  }

  Widget _buildNumberInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: OutlinedTextFormField(
        hintText: context.l10n.recurringDonationsCreateDurationNumberHint,
        initialValue: widget.uiModel.numberOfDonations,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        onChanged: (number) {
          widget.onNumberChanged(number);
          
          // Only show snackbar if start date is selected and frequency is available
          if (widget.uiModel.startDate == null || widget.frequency == null) return;
          
          final n = number.isNotEmpty ? number : 'X';
          DateTime endDate;
          if (number.isNotEmpty) {
            final numberOfDonations = int.tryParse(number) ?? 1;
            endDate = _calculateEndDateFromNumberOfDonations(
              widget.uiModel.startDate!,
              widget.frequency!,
              numberOfDonations,
            );
            widget.onDateChanged(endDate);
          } else {
            endDate = DateTime.now();
          }
          final formattedDate = DateFormat('dd MMMM yyyy').format(endDate);

          // Add a delay to ensure keyboard is closed before showing snackbar
          Timer(const Duration(milliseconds: 500), () {
            if (!context.mounted) return;
            
            if (n == '1') {
              _showSnackbarWithKeyboardCheck(
                context,
                context.l10n
                    .recurringDonationsCreateDurationSnackbarOnce(formattedDate),
                const Icon(
                  Icons.repeat,
                  color: Color(0xFF234B5E),
                  size: 32,
                ),
              );
            } else {
              _showSnackbarWithKeyboardCheck(
                context,
                context.l10n
                    .recurringDonationsCreateDurationSnackbarTimes(
                      formattedDate,
                      n,
                    ),
                const Icon(
                  Icons.repeat,
                  color: Color(0xFF234B5E),
                  size: 32,
                ),
              );
            }
          });
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FunDatePicker(
        selectedDate: widget.uiModel.endDate,
        onDateSelected: (date) {
          widget.onDateChanged(date);
          
          // Only show snackbar if start date is selected and frequency is available
          if (widget.uiModel.startDate == null || widget.frequency == null) return;
          
          final message = _buildSnackbarMessage(
            context,
            widget.frequency,
            widget.uiModel.startDate!,
            date,
          );
          
          // Add a small delay to ensure UI is stable
          Timer(const Duration(milliseconds: 200), () {
            if (!context.mounted) return;
            
            _showSnackbarWithKeyboardCheck(
              context,
              message,
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF234B5E),
                size: 32,
              ),
            );
          });
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

String _getDayWithOrdinal(DateTime date) {
  // Use localized ordinal formatting from the current locale
  final now = date.toMoment();
  return now.format('Do');
}
