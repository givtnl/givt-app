import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class FunTabs extends StatelessWidget {
  const FunTabs({
    required this.selections,
    required this.onPressed,
    required this.firstOption,
    required this.secondOption,
    required this.analyticsEvent,
    super.key,
  });

  final String firstOption;
  final String secondOption;
  final List<bool> selections;
  final void Function(int) onPressed;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderWidth: 2,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderColor: AppTheme.inputFieldBorderEnabled,
      selectedBorderColor: FamilyAppTheme.primary80,
      selectedColor: Colors.white,
      fillColor: FamilyAppTheme.primary80,
      color: FamilyAppTheme.primary80,
      constraints: BoxConstraints(
        minHeight: 44,
        minWidth: MediaQuery.of(context).size.width / 2 - 40,
      ),
      isSelected: selections,
      onPressed: (index) {
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent.name,
            eventProperties: analyticsEvent.parameters,
          ),
        );
        onPressed.call(index);
      },
      children: [
        LabelMediumText(firstOption),
        LabelMediumText(secondOption),
      ],
    );
  }
}
