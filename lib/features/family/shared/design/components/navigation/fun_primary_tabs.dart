import 'dart:async';

import 'package:collection/collection.dart';
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
    this.icons = const [],
    this.margin,
    super.key,
  });

  final List<String> options;
  final List<Widget?> icons;
  final int selectedIndex;
  final EdgeInsets? margin;
  final void Function(int) onPressed;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 24),
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
          ...options.mapIndexed(
            (index, option) => ButtonSegment(
              value: option,
              icon: icons.elementAtOrNull(index),
              label: LabelMediumText(
                option,
                color: FamilyAppTheme.primary40,
              ),
            ),
          ),
        ],
        selected: <String>{options[selectedIndex]},
        onSelectionChanged: (set) {
          final selectedOption = set.first;
          final newSelectedIndex = options.indexOf(selectedOption);

          // Pass back the index of the selected option, starting from 0
          onPressed(newSelectedIndex);

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
