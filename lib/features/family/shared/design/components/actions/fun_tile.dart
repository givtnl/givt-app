import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_app_theme.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

/// Visual variant of the tile; used to resolve theme colors when not
/// overridden.
enum FunTileVariant {
  gold,
  blue,
  green,
  red,
}

class FunTile extends StatelessWidget {
  const FunTile({
    required this.iconPath,
    required this.analyticsEvent,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.onTap,
    this.isDisabled = false,
    this.isSelected = false,
    this.isPressedDown = false,
    this.hasIcon = true,
    this.shrink = false,
    this.titleBig,
    this.titleMedium,
    this.titleSmall,
    this.subtitle,
    this.assetSize,
    this.padding,
    this.mainAxisAlignment,
    this.iconData,
    this.variant = FunTileVariant.gold,
    super.key,
  });

  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final String iconPath;
  final bool isDisabled;
  final bool isSelected;
  final bool isPressedDown;
  final bool shrink;
  final String? titleBig;
  final String? titleMedium;
  final String? titleSmall;
  final String? subtitle;
  final double? assetSize;
  final IconData? iconData;
  final Color? iconColor;
  final bool hasIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? padding;
  final AnalyticsEvent analyticsEvent;
  final FunTileVariant variant;

  ({Color border, Color bg, Color text, Color icon}) _themeColors(
    FunAppTheme theme,
  ) {
    return switch (variant) {
      FunTileVariant.gold => (
          border: theme.highlight80,
          bg: theme.highlight98,
          text: theme.highlight40,
          icon: theme.info20,
        ),
      FunTileVariant.blue => (
          border: theme.secondary80,
          bg: theme.secondary98,
          text: theme.secondary40,
          icon: theme.secondary20,
        ),
      FunTileVariant.green => (
          border: theme.primary80,
          bg: theme.primary98,
          text: theme.primary40,
          icon: theme.secondary20,
        ),
      FunTileVariant.red => (
          border: theme.error80,
          bg: theme.error98,
          text: theme.error40,
          icon: theme.error50,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final defaults = _themeColors(theme);
    final resolvedBorder = borderColor ?? defaults.border;
    final resolvedBg = backgroundColor ?? defaults.bg;
    final resolvedText = textColor ?? defaults.text;
    final resolvedIconColor = iconColor ?? defaults.icon;

    final isOnlineIcon = iconPath.startsWith('http');

    var newBackgroundColor = resolvedBg;
    var newBorderColor = resolvedBorder;

    if (isDisabled) {
      newBackgroundColor = theme.disabledTileBackground;
      newBorderColor = theme.disabledTileBorder;
    }

    return ActionContainer(
      isDisabled: isDisabled,
      isSelected: isSelected,
      isPressedDown: isPressedDown,
      borderColor: newBorderColor,
      analyticsEvent: analyticsEvent,
      onTap: isDisabled ? () {} : onTap,
      child: Stack(
        children: [
          Container(
            color: newBackgroundColor,
            width: double.infinity,
            constraints: const BoxConstraints(
              
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                children: [
                  if (hasIcon)
                    SizedBox(height: iconData != null && !shrink ? 24 : 10),
                  if (hasIcon)
                    Opacity(
                      opacity: isDisabled ? 0.5 : 1,
                      child: iconData == null
                          ? isOnlineIcon
                                ? SvgPicture.network(
                                    iconPath,
                                    height: assetSize ?? 140,
                                    width: assetSize ?? 140,
                                  )
                                : SvgPicture.asset(
                                    iconPath,
                                    height: assetSize ?? 140,
                                    width: assetSize ?? 140,
                                    colorFilter: ColorFilter.mode(
                                      resolvedIconColor,
                                      BlendMode.srcIn,
                                    ),
                                  )
                          : FaIcon(
                              iconData,
                              size: assetSize ?? 140,
                              color: resolvedIconColor,
                            ),
                    ),
                  Padding(
                    padding:
                        padding ??
                        (hasIcon
                            ? EdgeInsets.fromLTRB(10, 8, 10, shrink ? 0 : 16)
                            : EdgeInsets.zero),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (titleBig != null)
                          LabelLargeText(
                            titleBig!,
                            textAlign: TextAlign.center,
                            color: isDisabled
                                ? theme.disabledTileBorder
                                : resolvedText,
                          )
                        else
                          const SizedBox(),
                        if (titleMedium != null)
                          LabelMediumText(
                            titleMedium!,
                            textAlign: TextAlign.center,
                            color: isDisabled
                                ? theme.disabledTileBorder
                                : resolvedText,
                          )
                        else
                          const SizedBox(),
                        if (titleSmall != null)
                          LabelMediumText(
                            titleSmall!,
                            textAlign: TextAlign.center,
                            color: isDisabled
                                ? theme.disabledTileBorder
                                : resolvedText,
                          )
                        else
                          const SizedBox(),
                        if (hasIcon) const SizedBox(height: 4),
                        if (subtitle != null)
                          LabelMediumText(
                            subtitle!,
                            textAlign: TextAlign.center,
                            color: resolvedText.withValues(alpha: 0.7),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.primary70,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
