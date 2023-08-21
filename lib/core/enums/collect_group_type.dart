import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

enum CollecGroupType {
  church(
    icon: 'assets/images/church.png',
    activeIcon: 'assets/images/church_focus.png',
    color: AppTheme.givtLightBlue,
  ),
  campaign(
    icon: 'assets/images/campaign.png',
    activeIcon: 'assets/images/campaign_focus.png',
    color: AppTheme.givtOrange,
  ),
  artists(
    icon: 'assets/images/artist.png',
    activeIcon: 'assets/images/artist_focus.png',
    color: AppTheme.givtDarkGreen,
  ),
  charities(
    icon: 'assets/images/charity.png',
    activeIcon: 'assets/images/charity_focus.png',
    color: AppTheme.givtYellow,
  ),
  unknown(icon: '', activeIcon: '', color: Colors.grey),
  demo(icon: '', activeIcon: '', color: Colors.grey),
  debug(icon: '', activeIcon: '', color: Colors.grey),
  none(icon: '', activeIcon: '', color: Colors.grey);

  const CollecGroupType({
    required this.icon,
    required this.activeIcon,
    required this.color,
  });
  final String icon;
  final String activeIcon;
  final Color color;

  static CollecGroupType fromInt(int value) {
    if (value >= 0 && value < CollecGroupType.none.index) {
      return CollecGroupType.values[value];
    } else {
      return CollecGroupType.none;
    }
  }
}
