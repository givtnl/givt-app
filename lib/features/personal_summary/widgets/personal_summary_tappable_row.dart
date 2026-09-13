import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

/// Wraps a summary legend/chart row with tap handling and a trailing chevron.
class PersonalSummaryTappableRow extends StatelessWidget {
  const PersonalSummaryTappableRow({
    required this.onTap,
    required this.analyticsEvent,
    required this.child,
    this.showBottomBorder = true,
    super.key,
  });

  final VoidCallback onTap;
  final AnalyticsEvent analyticsEvent;
  final Widget child;
  final bool showBottomBorder;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          unawaited(
            AnalyticsHelper.logEvent(
              eventName: analyticsEvent.name,
              eventProperties: analyticsEvent.parameters,
            ),
          );
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: showBottomBorder
                    ? theme.neutralVariant95
                    : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(child: child),
              const SizedBox(width: 8),
              FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 16,
                color: theme.neutral60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
