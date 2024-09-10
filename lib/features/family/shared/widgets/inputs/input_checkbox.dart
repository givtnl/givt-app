import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class InputCheckbox extends StatelessWidget {
  const InputCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.analyticsEvent,
    super.key,
  });

  final String label;
  final bool value;
  final AnalyticsEvent analyticsEvent;
  final void Function(bool? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (value) {
            AnalyticsHelper.logEvent(
              eventName: analyticsEvent.name,
              eventProperties: {
                'value': value,
                ...analyticsEvent.parameters,
              },
            );

            onChanged?.call(value);
          },
        ),
        Flexible(
          child: BodySmallText(label),
        ),
      ],
    );
  }
}
