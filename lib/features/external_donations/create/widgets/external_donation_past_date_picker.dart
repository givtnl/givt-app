import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

/// Read-only date field that opens a past-only date picker.
class ExternalDonationPastDatePicker extends StatefulWidget {
  const ExternalDonationPastDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
    this.label,
    super.key,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? label;

  @override
  State<ExternalDonationPastDatePicker> createState() =>
      _ExternalDonationPastDatePickerState();
}

class _ExternalDonationPastDatePickerState
    extends State<ExternalDonationPastDatePicker> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncControllerText();
  }

  @override
  void didUpdateWidget(ExternalDonationPastDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _syncControllerText();
    }
  }

  void _syncControllerText() {
    final newText = _formatDisplay();
    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  String _formatDisplay() {
    if (widget.selectedDate == null) {
      return '';
    }
    return MaterialLocalizations.of(context)
        .formatMediumDate(widget.selectedDate!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FunInput(
      label: widget.label,
      controller: _controller,
      readOnly: true,
      hintText: context.l10n.externalDonationsCreateSelectDateHint,
      suffixIcon: Icon(Icons.calendar_today, color: FunTheme.of(context).neutral40),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: widget.selectedDate ?? now,
          firstDate: DateTime(now.year - 30),
          lastDate: now,
        );
        if (picked != null) {
          widget.onDateSelected(picked);
        }
      },
    );
  }
}
