import 'package:flutter/material.dart';
import 'package:givt_app/shared/design_system/components/input/fun_input.dart';
import 'package:givt_app/shared/design_system/components/input/fun_input_label.dart';
import 'package:givt_app/shared/design_system/theme/fun_theme.dart';
import 'package:intl/intl.dart';

class FunDatePicker extends StatefulWidget {
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

  @override
  State<FunDatePicker> createState() => _FunDatePickerState();
}

class _FunDatePickerState extends State<FunDatePicker> {
  late TextEditingController _displayController;

  String _formatDisplay() {
    return widget.selectedDate != null
        ? DateFormat('d MMMM yyyy').format(widget.selectedDate!)
        : 'Select date';
  }

  FunInputLabelState _labelState() {
    if (!widget.enabled) {
      return FunInputLabelState.disabled;
    }
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      return FunInputLabelState.error;
    }
    if (widget.selectedDate != null) {
      return FunInputLabelState.filled;
    }
    return FunInputLabelState.defaultState;
  }

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(text: _formatDisplay());
  }

  @override
  void didUpdateWidget(FunDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newText = _formatDisplay();
    if (_displayController.text != newText) {
      _displayController.text = newText;
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final picker = GestureDetector(
      onTap: widget.enabled
          ? () async {
              final now = DateTime.now().add(const Duration(days: 1));
              final picked = await showDatePicker(
                context: context,
                initialDate: widget.selectedDate ?? now,
                firstDate: now,
                lastDate: DateTime(now.year + 10),
              );
              if (picked != null) {
                widget.onDateSelected(picked);
              }
            }
          : null,
      child: AbsorbPointer(
        child: FunInput(
          controller: _displayController,
          hintText: 'Select date',
          readOnly: true,
          enabled: widget.enabled,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: FunTheme.of(context).neutral40,
            ),
            onPressed: null,
          ),
        ),
      ),
    );

    return LabeledField(
      label: widget.label,
      labelState: _labelState(),
      child: picker,
    );
  }
}
