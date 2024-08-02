import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/utils/utils.dart';

class InputCheckbox extends StatelessWidget {
  const InputCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.amplitudeEvent,
    super.key,
  });

  final String label;
  final bool value;
  final AmplitudeEvents amplitudeEvent;
  final void Function(bool? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (value) {
            AnalyticsHelper.logEvent(
              eventName: amplitudeEvent,
              eventProperties: {
                'value': value,
              },
            );
            
            onChanged?.call(value);
          },
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
