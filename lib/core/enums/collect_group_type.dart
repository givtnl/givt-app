import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/utils/app_theme.dart';

enum CollectGroupType {
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

  const CollectGroupType({
    required this.icon,
    required this.activeIcon,
    required this.color,
  });
  final String icon;
  final String activeIcon;
  final Color color;

  static CollectGroupType fromInt(int value) {
    if (value >= 0 && value < CollectGroupType.none.index) {
      return CollectGroupType.values[value];
    } else {
      return CollectGroupType.none;
    }
  }

  static IconData getIconByType(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return FontAwesomeIcons.placeOfWorship;
      case CollectGroupType.charities:
        return FontAwesomeIcons.heart;
      case CollectGroupType.campaign:
        return FontAwesomeIcons.handHoldingHeart;
      case CollectGroupType.artists:
        return FontAwesomeIcons.guitar;
      default:
    }
    return FontAwesomeIcons.church;
  }

  static Color getHighlightColor(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return AppTheme.givtLightBlue;
      case CollectGroupType.charities:
        return AppTheme.givtYellow;
      case CollectGroupType.campaign:
        return AppTheme.givtOrange;
      case CollectGroupType.artists:
        return AppTheme.givtDarkGreen;
      default:
    }
    return AppTheme.givtLightBlue;
  }
}
