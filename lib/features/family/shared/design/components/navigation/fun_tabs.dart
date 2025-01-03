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
  final void Function(int) onPressed;
  final AnalyticsEvent analyticsEvent;

  Widget _buildTab(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        unawaited(
          AnalyticsHelper.logEvent(
            eventName: analyticsEvent.name,
            eventProperties: {
              'selected_option': options[index],
              'selected_index': index,
            },
          ),
        );
        onPressed.call(index);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: index == selectedIndex ? Colors.white : null,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: LabelMediumText(
          options[index],
          color: index == selectedIndex
              ? FamilyAppTheme.primary20
              : Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: FamilyAppTheme.neutralVariant90,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: List.generate(
          options.length,
          (index) => Expanded(child: _buildTab(context, index)),
        ),
      ),
    );
  }
}
