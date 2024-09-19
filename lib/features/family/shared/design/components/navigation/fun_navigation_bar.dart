import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class FunNavigationBar extends StatelessWidget {
  const FunNavigationBar({
    required this.index,
    required this.onDestinationSelected,
    required this.destinations,
    required this.analyticsEvent,
    super.key,
  });

  final int index;
  final void Function(int) onDestinationSelected;
  final List<Widget> destinations;
  final AnalyticsEvent Function(int) analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: const TextTheme(
          labelMedium: TextStyle(
            fontFamily: 'Rouna',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        colorScheme: Theme.of(context).colorScheme,
      ),
      child: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: index,
        onDestinationSelected: (index) {
          final analyticsEvent = this.analyticsEvent(index);
          unawaited(
            AnalyticsHelper.logEvent(
              eventName: analyticsEvent.name,
              eventProperties: analyticsEvent.parameters,
            ),
          );
          onDestinationSelected.call(index);
        },
        backgroundColor: FamilyAppTheme.secondary99,
        indicatorColor: FamilyAppTheme.secondary95,
        surfaceTintColor: Colors.transparent,
        destinations: destinations,
      ),
    );
  }
}
