import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_label.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:intl/intl.dart';

class FunDatePicker extends StatelessWidget {
  const FunDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.label,
    this.enabled = true,
    this.errorText,
    super.key,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? label;
  final bool enabled;
  final String? errorText;

  FunInputLabelState _labelState() {
    if (!enabled) {
      return FunInputLabelState.disabled;
    }
    if (errorText != null && errorText!.isNotEmpty) {
      return FunInputLabelState.error;
    }
    if (selectedDate != null) {
      return FunInputLabelState.filled;
    }
    return FunInputLabelState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = selectedDate != null
        ? DateFormat('d MMMM yyyy').format(selectedDate!)
        : 'Select date';

    final picker = GestureDetector(
      onTap: enabled
          ? () async {
              final now = DateTime.now().add(const Duration(days: 1));
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? now,
                firstDate: now,
                lastDate: DateTime(now.year + 10),
              );
              if (picked != null) {
                onDateSelected(picked);
              }
            }
          : null,
      child: AbsorbPointer(
        child: OutlinedTextFormField(
          key: ValueKey(displayDate),
          hintText: 'Select date',
          initialValue: displayDate,
          readOnly: true,
          enabled: enabled,
          suffixIcon: const IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: null,
          ),
        ),
      ),
    );

    return LabeledField(
      label: label,
      labelState: _labelState(),
      child: picker,
    );
  }
}
