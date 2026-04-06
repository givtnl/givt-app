import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/color_combo.dart';
import 'package:givt_app/utils/app_theme.dart';

enum CollectGroupType {
  church(
    iconData: FontAwesomeIcons.church,
    color: AppTheme.givtLightBlue,
  ),
  campaign(
    iconData: FontAwesomeIcons.bullhorn,
    color: AppTheme.givtOrange,
  ),
  artists(
    iconData: FontAwesomeIcons.guitar,
    color: AppTheme.givtDarkGreen,
  ),
  charities(
    iconData: FontAwesomeIcons.earthEurope,
    color: AppTheme.givtYellow,
  ),
  unknown(
    iconData: FontAwesomeIcons.circleQuestion,
    color: Colors.grey,
  ),
  demo(
    iconData: FontAwesomeIcons.circleQuestion,
    color: Colors.grey,
  ),
  debug(
    iconData: FontAwesomeIcons.circleQuestion,
    color: Colors.grey,
  ),
  none(
    iconData: FontAwesomeIcons.circleQuestion,
    color: Colors.grey,
  );

  const CollectGroupType({
    required this.iconData,
    required this.color,
  });

  /// Font Awesome icon for this collect group (single source of truth for EU/US).
  final IconData iconData;
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

  /// Order for organisation search filter chips: Church, Charity, Campaign,
  /// Others ([artists]). Types outside this list are sorted after, by index.
  static int compareForOrganisationFilterBar(
    CollectGroupType a,
    CollectGroupType b,
  ) {
    const ordered = [
      CollectGroupType.church,
      CollectGroupType.charities,
      CollectGroupType.campaign,
      CollectGroupType.artists,
    ];
    final ia = ordered.indexOf(a);
    final ib = ordered.indexOf(b);
    final ra = ia == -1 ? ordered.length : ia;
    final rb = ib == -1 ? ordered.length : ib;
    final c = ra.compareTo(rb);
    if (c != 0) {
      return c;
    }
    return a.index.compareTo(b.index);
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
      case CollectGroupType.unknown:
      case CollectGroupType.demo:
      case CollectGroupType.debug:
      case CollectGroupType.none:
        return ColorCombo.secondary;
    }
  }

  static IconData getIconByType(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return FontAwesomeIcons.church;
      case CollectGroupType.charities:
        return FontAwesomeIcons.earthEurope;
      case CollectGroupType.campaign:
        return FontAwesomeIcons.bullhorn;
      case CollectGroupType.artists:
        return FontAwesomeIcons.guitar;
      case CollectGroupType.unknown:
      case CollectGroupType.demo:
      case CollectGroupType.debug:
      case CollectGroupType.none:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  static FunIcon getFunIconByType(CollectGroupType type) {
    switch (type) {
      case CollectGroupType.church:
        return FunIcon.church();
      case CollectGroupType.charities:
        return FunIcon(
          iconData: FontAwesomeIcons.earthEurope,
          circleColor: ColorCombo.tertiary.backgroundColor,
          iconColor: ColorCombo.tertiary.textColor,
        );
      case CollectGroupType.campaign:
        return FunIcon(
          iconData: FontAwesomeIcons.bullhorn,
          circleColor: ColorCombo.highlight.backgroundColor,
          iconColor: ColorCombo.highlight.textColor,
        );
      case CollectGroupType.artists:
        return FunIcon.guitar(
          circleColor: ColorCombo.secondary.backgroundColor,
          iconColor: ColorCombo.secondary.textColor,
        );
      case CollectGroupType.unknown:
      case CollectGroupType.demo:
      case CollectGroupType.debug:
      case CollectGroupType.none:
        return FunIcon.circleQuestion();
    }
  }

  /// Same mapping as [getIconByType] (US-specific variants were unified).
  static IconData getIconByTypeUS(CollectGroupType type) => getIconByType(type);

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
      case CollectGroupType.unknown:
      case CollectGroupType.demo:
      case CollectGroupType.debug:
      case CollectGroupType.none:
        return AppTheme.givtLightBlue;
    }
  }
}
