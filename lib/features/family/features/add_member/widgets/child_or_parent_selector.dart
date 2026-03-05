import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_primary_tabs.dart';

class ChildOrParentSelector extends StatelessWidget {
  const ChildOrParentSelector({
    required this.selectedIndex,
    required this.onPressed,
    required this.options,
    super.key,
  });

  final int selectedIndex;
  final void Function(int) onPressed;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return FunPrimaryTabs(
      selectedIndex: selectedIndex,
      onPressed: onPressed,
      options: options,
      analyticsEvent: AnalyticsEventName.addMemberTypeSelectorClicked.toEvent(),
    );
  }
}
