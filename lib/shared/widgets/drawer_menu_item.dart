import 'dart:async';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/utils.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    required this.title,
    required this.leading,
    required this.onTap,
    required this.analyticsEvent,
    this.isVisible = true,
    this.showBadge = false,
    this.semanticsIdentifier,
    super.key,
  });

  final bool isVisible;
  final bool showBadge;
  final String title;
  final Widget leading;
  final VoidCallback onTap;
  final AnalyticsEventName analyticsEvent;
  final String? semanticsIdentifier;

  void _handleTap() {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: analyticsEvent,
      ),
    );
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Center(child: leading),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: LabelMediumText(
              title,
              color: theme.primary20,
              fontWeight: FontWeight.w600,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          badges.Badge(
            showBadge: showBadge,
            position: badges.BadgePosition.topStart(top: 6, start: -20),
            child: FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 20,
              color: theme.primary50.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.neutralVariant95, width: 2),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            child: row,
          ),
        ),
      ),
    );

    return Visibility(
      visible: isVisible,
      child: semanticsIdentifier == null
          ? content
          : Semantics(
              identifier: semanticsIdentifier,
              button: true,
              child: content,
            ),
    );
  }
}
