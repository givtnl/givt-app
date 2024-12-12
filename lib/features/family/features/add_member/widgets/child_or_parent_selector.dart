import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_tabs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class ChildOrParentSelector extends StatelessWidget {
  const ChildOrParentSelector({
    required this.selectedIndex,
    required this.onPressed,
    super.key,
  });

  final int selectedIndex;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return FunTabs(
      selectedIndex: selectedIndex,
      onPressed: onPressed,
      options: const ['Child', 'Parent'],
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.addMemberTypeSelectorClicked,
      ),
    );
  }
}
