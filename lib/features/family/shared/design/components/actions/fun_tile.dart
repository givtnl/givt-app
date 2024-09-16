import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class FunTile extends StatelessWidget {
  const FunTile({
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    required this.iconPath,
    required this.analyticsEvent,
    this.onTap,
    this.isDisabled = false,
    this.isSelected = false,
    this.titleBig,
    this.titleSmall,
    this.subtitle,
    this.assetSize,
    this.mainAxisAlignment,
    this.iconData,
    this.iconColor,
    super.key,
  });

  factory FunTile.gold({
    required AnalyticsEvent analyticsEvent,
    String? titleBig,
    String? titleSmall,
    String? subtitle,
    IconData? iconData,
    VoidCallback? onTap,
    double? assetSize,
  }) {
    return FunTile(
      borderColor: FamilyAppTheme.highlight80,
      backgroundColor: FamilyAppTheme.highlight98,
      textColor: FamilyAppTheme.highlight40,
      iconPath: '',
      onTap: onTap,
      titleBig: titleBig,
      titleSmall: titleSmall,
      subtitle: subtitle,
      iconData: iconData,
      assetSize: assetSize,
      iconColor: FamilyAppTheme.info20,
      analyticsEvent: analyticsEvent,
    );
  }

  factory FunTile.blue({
    required AnalyticsEvent analyticsEvent,
    String? titleBig,
    String? titleSmall,
    String? subtitle,
    IconData? iconData,
    VoidCallback? onTap,
    double? assetSize,
  }) {
    return FunTile(
      borderColor: FamilyAppTheme.secondary80,
      backgroundColor: FamilyAppTheme.secondary98,
      textColor: FamilyAppTheme.secondary40,
      iconPath: '',
      onTap: onTap,
      titleBig: titleBig,
      titleSmall: titleSmall,
      subtitle: subtitle,
      iconData: iconData,
      assetSize: assetSize,
      iconColor: FamilyAppTheme.secondary20,
      analyticsEvent: analyticsEvent,
    );
  }

  final VoidCallback? onTap;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final bool isDisabled;
  final bool isSelected;
  final String? titleBig;
  final String? titleSmall;
  final String? subtitle;
  final double? assetSize;
  final IconData? iconData;
  final Color? iconColor;
  final MainAxisAlignment? mainAxisAlignment;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    final isOnlineIcon = iconPath.startsWith('http');

    var newBackgroundColor = backgroundColor;
    var newBorderColor = borderColor;

    if (isDisabled) {
      newBackgroundColor = FamilyAppTheme.disabledTileBackground;
      newBorderColor = FamilyAppTheme.disabledTileBorder;
    }

    return ActionContainer(
      isDisabled: isDisabled,
      isSelected: isSelected,
      borderColor: newBorderColor,
      analyticsEvent: analyticsEvent,
      onTap: isDisabled ? () {} : onTap,
      child: Stack(
        children: [
          Container(
            color: newBackgroundColor,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
              children: [
                SizedBox(height: iconData != null ? 24 : 10),
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
                            )
                      : FaIcon(
                          iconData,
                          size: assetSize ?? 140,
                          color: iconColor ?? textColor.withOpacity(0.6),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                  child: Column(
                    children: [
                      if (titleBig != null)
                        Text(
                          titleBig!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: isDisabled
                                        ? FamilyAppTheme.disabledTileBorder
                                        : textColor,
                                  ),
                        )
                      else
                        const SizedBox(),
                      if (titleSmall != null)
                        Text(
                          titleSmall!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: isDisabled
                                        ? FamilyAppTheme.disabledTileBorder
                                        : textColor,
                                  ),
                        )
                      else
                        const SizedBox(),
                      const SizedBox(height: 8),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: textColor.withAlpha(200),
                                  ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: FamilyAppTheme.primary70,
                  borderRadius: BorderRadius.only(
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
