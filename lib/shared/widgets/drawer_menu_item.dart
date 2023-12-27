

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isVisible = false,
    this.showBadge = false,
    this.showUnderline = false,
    this.isAccent = false,
    super.key,
    this.imageIcon,
  });

  final bool isVisible;
  final bool showBadge;
  final bool showUnderline;
  final bool isAccent;
  final String title;
  final IconData icon;
  final Widget? imageIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          Container(
            height: isAccent ? 90 : 60,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.givtLightGray,
                  width: showUnderline ? 1 : 0,
                ),
              ),
            ),
            child: isAccent
                ? ListTile(
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                    title: Row(
                      children: [
                        imageIcon ??
                            Icon(
                              icon,
                              color: AppTheme.givtBlue,
                            ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ],
                    ),
                    onTap: onTap,
                  )
                : ListTile(
                    leading: imageIcon ??
                        Icon(
                          icon,
                          color: AppTheme.givtBlue,
                        ),
                    trailing: badges.Badge(
                      showBadge: showBadge,
                      position:
                          badges.BadgePosition.topStart(top: 6, start: -20),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                            isAccent ? FontWeight.w900 : FontWeight.normal,
                      ),
                    ),
                    onTap: onTap,
                  ),
          ),
        ],
      ),
    );
  }
}
