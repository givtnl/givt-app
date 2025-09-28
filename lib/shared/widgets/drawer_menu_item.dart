import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.analyticsEvent,
    this.isVisible = false,
    this.showBadge = false,
    this.isAccent = false,
    super.key,
    this.imageIcon,
  });

  final bool isVisible;
  final bool showBadge;
  final bool isAccent;
  final String title;
  final IconData icon;
  final Widget? imageIcon;
  final VoidCallback onTap;
  final AmplitudeEvents analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          Container(
            height: isAccent ? 90 : 60,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: FamilyAppTheme.neutral95,
                ),
              ),
            ),
            child: isAccent
                ? ListTile(
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                    title: Row(
                      children: [
                        imageIcon ??
                            FaIcon(
                              icon,
                              color: FamilyAppTheme.primary20,
                            ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: LabelMediumText(
                              title,
                            ),
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.chevronRight,
                          color: FamilyAppTheme.primary50.withValues(
                            alpha: 0.5,
                          ),
                          size: 20,
                        ),
                      ],
                    ),
                    onTap: () {
                      unawaited(
                        AnalyticsHelper.logEvent(
                          eventName: analyticsEvent,
                        ),
                      );
                      onTap();
                    },
                  )
                : ListTile(
                    leading:
                        imageIcon ??
                        FaIcon(
                          icon,
                          color: FamilyAppTheme.primary20,
                        ),
                    trailing: badges.Badge(
                      showBadge: showBadge,
                      position: badges.BadgePosition.topStart(
                        top: 6,
                        start: -20,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: FamilyAppTheme.primary50.withValues(alpha: 0.5),
                        size: 20,
                      ),
                    ),
                    title: BodySmallText(
                      title,
                    ),
                    onTap: () {
                      unawaited(
                        AnalyticsHelper.logEvent(
                          eventName: analyticsEvent,
                        ),
                      );
                      onTap();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
