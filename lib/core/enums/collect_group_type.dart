import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/color_combo.dart';
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

  static CollectGroupType fromString(String value) {
    for (final type in CollectGroupType.values) {
      if (type.name.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    return CollectGroupType.none;
  }

  static ColorCombo getColorComboByType(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return ColorCombo.primary;
      case CollectGroupType.charities:
        return ColorCombo.tertiary;
      case CollectGroupType.campaign:
        return ColorCombo.highlight;
      case CollectGroupType.artists:
        return ColorCombo.secondary;
      default:
    }
    return ColorCombo.secondary;
  }

  static IconData getIconByType(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return FontAwesomeIcons.placeOfWorship;
      case CollectGroupType.charities:
        return FontAwesomeIcons.solidHeart;
      case CollectGroupType.campaign:
        return FontAwesomeIcons.handHoldingHeart;
      case CollectGroupType.artists:
        return FontAwesomeIcons.guitar;
      default:
    }
    return FontAwesomeIcons.church;
  }

  static FunIcon getFunIconByType(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return FunIcon.church();
      case CollectGroupType.charities:
        return FunIcon.globe(
          circleColor: ColorCombo.tertiary.backgroundColor,
          iconColor: ColorCombo.tertiary.textColor,
        );
      case CollectGroupType.campaign:
        return FunIcon.seedling(
          circleColor: ColorCombo.highlight.backgroundColor,
          iconColor: ColorCombo.highlight.textColor,
        );
      case CollectGroupType.artists:
        return FunIcon.guitar(
          circleColor: ColorCombo.secondary.backgroundColor,
          iconColor: ColorCombo.secondary.textColor,
        );
      default:
    }
    return FunIcon.church();
  }

  static IconData getIconByTypeUS(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return FontAwesomeIcons.church;
      case CollectGroupType.charities:
        return FontAwesomeIcons.earthAmericas;
      case CollectGroupType.campaign:
        return FontAwesomeIcons.seedling;
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
