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
  one,
  two,
  three,
  five,
}

class FunTile extends StatelessWidget {
  static const _maxIconSize = 140.0;
  static const _iconFraction = 1.0;
  static const _defaultPadding = EdgeInsets.all(12);

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
    this.iconWidget,
    this.variant = FunTileVariant.one,
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
  final Widget? iconWidget;
  final bool hasIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? padding;
  final AnalyticsEvent analyticsEvent;
  final FunTileVariant variant;

  ({Color border, Color bg, Color text, Color icon}) _themeColors(
    FunAppTheme theme,
  ) {
    return switch (variant) {
      FunTileVariant.one => (
        border: theme.highlight80,
        bg: theme.highlight98,
        text: theme.highlight40,
        icon: theme.highlight95,
      ),
      FunTileVariant.three => (
        border: theme.secondary80,
        bg: theme.secondary98,
        text: theme.secondary40,
        icon: theme.secondary95,
      ),
      FunTileVariant.two => (
        border: theme.primary80,
        bg: theme.primary98,
        text: theme.primary40,
        icon: theme.primary95,
      ),
      FunTileVariant.five => (
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

    final resolvedPadding = padding ??
        (hasIcon
            ? _defaultPadding.copyWith(top: 0)
            : _defaultPadding);

    return ActionContainer(
      isDisabled: isDisabled,
      isSelected: isSelected,
      isPressedDown: isPressedDown,
      borderColor: newBorderColor,
      analyticsEvent: analyticsEvent,
      onTap: isDisabled ? () {} : onTap,
      borderSize: FunTheme.of(context).borderWidthThin,
      baseBorderSize:
          FunTheme.of(context).borderWidthThin + theme.shadowYSm,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(color: newBackgroundColor),
          ),
          Container(
            width: double.infinity,
            padding: resolvedPadding,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    mainAxisAlignment ?? MainAxisAlignment.start,
                children: [
                  if (hasIcon)
                    SizedBox(
                      height: iconData != null && !shrink ? 16 : 8,
                    ),
                  if (hasIcon)
                    Opacity(
                      opacity: isDisabled ? 0.5 : 1,
                      child: iconWidget ??
                          (iconData == null
                              ? _buildResponsiveIcon(
                                  isOnlineIcon: isOnlineIcon,
                                  resolvedIconColor: resolvedIconColor,
                                )
                              : FaIcon(
                                  iconData,
                                  size: assetSize ?? 48,
                                  color: resolvedIconColor,
                                )),
                    ),
                  if (hasIcon)
                    SizedBox(height: shrink ? 4 : 12),
                  _buildLabels(
                    theme: theme,
                    resolvedText: resolvedText,
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
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabels({
    required FunAppTheme theme,
    required Color resolvedText,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleBig != null)
          LabelLargeText(
            titleBig!,
            textAlign: TextAlign.center,
            color: isDisabled
                ? theme.disabledTileBorder
                : resolvedText,
          ),
        if (titleMedium != null)
          LabelMediumText(
            titleMedium!,
            textAlign: TextAlign.center,
            color: isDisabled
                ? theme.disabledTileBorder
                : resolvedText,
          ),
        if (titleSmall != null)
          LabelMediumText(
            titleSmall!,
            textAlign: TextAlign.center,
            color: isDisabled
                ? theme.disabledTileBorder
                : resolvedText,
          ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          LabelMediumText(
            subtitle!,
            textAlign: TextAlign.center,
            color: resolvedText.withValues(alpha: 0.7),
          ),
        ],
      ],
    );
  }

  /// Wraps the icon in [FractionallySizedBox] + [ConstrainedBox] +
  /// [AspectRatio] so it scales to a fraction of the available width
  /// while respecting a maximum size. Unlike [LayoutBuilder] this
  /// supports intrinsic-dimension queries (needed by [IntrinsicHeight]).
  Widget _buildResponsiveIcon({
    required bool isOnlineIcon,
    required Color resolvedIconColor,
  }) {
    final maxSize = assetSize ?? _maxIconSize;
    return FractionallySizedBox(
      widthFactor: _iconFraction,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxSize,
          maxHeight: maxSize,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: _buildIconFromPath(
            isOnlineIcon: isOnlineIcon,
            resolvedIconColor: resolvedIconColor,
          ),
        ),
      ),
    );
  }

  Widget _buildIconFromPath({
    required bool isOnlineIcon,
    required Color resolvedIconColor,
  }) {
    final isSvg = iconPath.toLowerCase().endsWith('.svg');
    if (isSvg) {
      return Container(
        decoration: BoxDecoration(
          color: resolvedIconColor,
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: isOnlineIcon
            ? SvgPicture.network(iconPath, fit: BoxFit.cover)
            : SvgPicture.asset(
                iconPath,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  resolvedIconColor,
                  BlendMode.srcIn,
                ),
              ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: resolvedIconColor,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: isOnlineIcon
          ? Image.network(iconPath, fit: BoxFit.cover)
          : Image.asset(iconPath, fit: BoxFit.cover),
    );
  }
}
