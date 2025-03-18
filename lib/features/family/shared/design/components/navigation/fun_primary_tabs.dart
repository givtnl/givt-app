import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class FunPrimaryTabs extends StatelessWidget {
  const FunPrimaryTabs({
    required this.options,
    required this.selectedIndex,
    required this.onPressed,
    required this.analyticsEvent,
    this.margin,
    super.key,
  });

  final List<String> options;
  final int selectedIndex;
  final EdgeInsets? margin;
  final void Function(Set<String>) onPressed;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: SegmentedButton<String>(
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.white,
          selectedForegroundColor: FamilyAppTheme.primary40,
          selectedBackgroundColor: FamilyAppTheme.primary95,
          side: const BorderSide(
            width: 2,
            color: FamilyAppTheme.primary40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        segments: [
          ...options.map(
            (option) => ButtonSegment(
              value: option,
              label: LabelMediumText(
                option,
                color: FamilyAppTheme.primary40,
              ),
            ),
          ),
        ],
        selected: <String>{options[selectedIndex]},
        onSelectionChanged: (set) {
          onPressed(set);
          final selectedOption = set.first;
          final newSelectedIndex = options.indexOf(selectedOption);
          unawaited(
            AnalyticsHelper.logEvent(
              eventName: analyticsEvent.name,
              eventProperties: {
                'selected_option': selectedOption,
                'selected_index': newSelectedIndex,
              },
            ),
          );
        },
      ),
    );
  }
}
