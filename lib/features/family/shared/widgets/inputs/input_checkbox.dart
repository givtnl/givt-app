import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class InputCheckbox extends StatelessWidget {
  const InputCheckbox({
    required this.label,
    required this.semanticsLabel,
    required this.value,
    required this.onChanged,
    required this.analyticsEvent,
    super.key,
  });

  final String label;
  final String semanticsLabel;
  final bool value;
  final AnalyticsEvent analyticsEvent;
  final void Function(bool? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          semanticLabel: semanticsLabel,
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
