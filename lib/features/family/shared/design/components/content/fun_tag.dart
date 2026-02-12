import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_app_theme.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/models/color_combo.dart';

// Which side of the tag should be flat (non-circular)
enum FlatSide { left, right, none }

/// Visual variant of the tag; used to resolve text and accent colors from
/// theme when the color parameters are not set.
enum FunTagVariant {
  primary,
  secondary,
  tertiary,
  highlight,
}

class FunTag extends StatelessWidget {
  const FunTag({
    required this.text,
    this.textColor,
    this.accentColor,
    this.variant,
    super.key,
    this.subtitle,
    this.borderRadius,
    this.iconData,
    this.flatSide = FlatSide.none,
    this.iconSize,
    this.fontFeatures,
  }) : assert(
         variant != null || (textColor != null && accentColor != null),
         'Either variant or both textColor and accentColor must be set',
       );

  factory FunTag.fromArea({
    required Areas area,
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
    double? iconSize,
    String? subtitle,
  }) {
    return FunTag(
      text: text,
      subtitle: subtitle,
      textColor: area.textColor,
      accentColor: area.accentColor,
      iconData: iconData,
      flatSide: flatSide,
      iconSize: iconSize,
    );
  }

  factory FunTag.fromTag({
    required Tag tag,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.fromArea(
      text: tag.displayText,
      subtitle: tag.subtitle,
      area: tag.area,
      iconData: tag.iconData,
      flatSide: flatSide,
      iconSize: tag.iconSize,
    );
  }

  factory FunTag.fromColorCombo({
    required ColorCombo combo,
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
    double? iconSize,
    List<FontFeature>? fontFeatures,
  }) {
    return FunTag(
      text: text,
      textColor: combo.textColor,
      accentColor: combo.accentColor,
      iconData: iconData,
      flatSide: flatSide,
      iconSize: iconSize,
      fontFeatures: fontFeatures,
    );
  }

  factory FunTag.xp(int xp) {
    return FunTag.fromArea(
      area: Areas.gold,
      text: '$xp XP',
      iconData: Icons.bolt,
      iconSize: 16,
    );
  }

  final String text;
  final String? subtitle;
  final Color? textColor;
  final Color? accentColor;
  final FunTagVariant? variant;
  final BorderRadius? borderRadius;
  final IconData? iconData;
  final FlatSide flatSide;
  final double? iconSize;
  final List<FontFeature>? fontFeatures;

  ({Color text, Color accent}) _themeColors(
    FunAppTheme theme,
    FunTagVariant v,
  ) {
    return switch (v) {
      FunTagVariant.primary => (
          text: theme.primary40,
          accent: theme.primary95,
        ),
      FunTagVariant.secondary => (
          text: theme.secondary40,
          accent: theme.secondary95,
        ),
      FunTagVariant.tertiary => (
          text: theme.tertiary40,
          accent: theme.tertiary95,
        ),
      FunTagVariant.highlight => (
          text: theme.highlight40,
          accent: theme.highlight95,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final resolved = variant != null
        ? _themeColors(theme, variant!)
        : (text: textColor!, accent: accentColor!);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: resolved.accent,
        borderRadius: borderRadius ?? _getBorderRadius(),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: flatSide == FlatSide.left ? 16 : 12,
          right: flatSide == FlatSide.right ? 16 : 12,
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconData != null)
                  Icon(
                    iconData,
                    color: resolved.text,
                    size: iconSize,
                  ),
                if (iconData != null) const SizedBox(width: 4),
                LabelSmallText(
                  text,
                  color: resolved.text,
                  fontFeatures: fontFeatures,
                ),
              ],
            ),
            if (subtitle != null)
              LabelThinText(subtitle!, color: resolved.text),
          ],
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    switch (flatSide) {
      case FlatSide.right:
        return const BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        );
      case FlatSide.left:
        return const BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        );
      case FlatSide.none:
        return const BorderRadius.all(
          Radius.circular(25),
        );
    }
  }
}
