import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:intl/intl.dart';

class FunDatePicker extends StatelessWidget {
  const FunDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    Key? key,
  }) : super(key: key);

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final displayDate = selectedDate != null
        ? DateFormat('d MMMM yyyy').format(selectedDate!)
        : 'Select date';

    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? now,
          firstDate: now,
          lastDate: DateTime(now.year + 10),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: AbsorbPointer(
        child: OutlinedTextFormField(
          key: ValueKey(displayDate),
          hintText: 'Select date',
          initialValue: displayDate,
          readOnly: true,
          suffixIcon: const IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
