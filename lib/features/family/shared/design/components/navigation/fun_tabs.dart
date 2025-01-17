import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_medium_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class FunTabs extends StatelessWidget {
  const FunTabs({
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
          ...options
              .map((option) => ButtonSegment(
                    value: option,
                    label: LabelMediumText(
                      option,
                      color: FamilyAppTheme.primary40,
                    ),
                  ))
              .toList(),
        ],
        selected: <String>{options[selectedIndex]},
        onSelectionChanged: (set) {
          onPressed(set);
          unawaited(
            AnalyticsHelper.logEvent(
              eventName: analyticsEvent.name,
              eventProperties: {
                'selected_option': options[selectedIndex],
                'selected_index': selectedIndex,
              },
            ),
          );
        },
      ),
    );
  }
}
