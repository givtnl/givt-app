import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/layout/action_container.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunTile extends StatefulWidget {
  const FunTile({
    required this.onTap,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    required this.iconPath,
    this.isDisabled = false,
    this.isSelected = false,
    this.titleBig = '',
    this.titleSmall = '',
    this.subtitle = '',
    this.assetSize,
    this.mainAxisAlignment,
    this.iconData,
    super.key,
  });

  final VoidCallback onTap;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final bool isDisabled;
  final bool isSelected;
  final String titleBig;
  final String titleSmall;
  final String subtitle;
  final double? assetSize;
  final IconData? iconData;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  State<FunTile> createState() => _FunTileState();
}

class _FunTileState extends State<FunTile> {
  late Color backgroundColor;
  late Color borderColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = widget.backgroundColor;
    borderColor = widget.borderColor;
    final isOnlineIcon = widget.iconPath.contains('http');

    if (widget.isDisabled) {
      backgroundColor = FamilyAppTheme.disabledTileBackground;
      borderColor = FamilyAppTheme.disabledTileBorder;
    }
    return ActionContainer(
      isDisabled: widget.isDisabled,
      isSelected: widget.isSelected,
      borderColor: borderColor,
      onTap: widget.isDisabled ? () {} : () => widget.onTap(),
      child: Stack(
        children: [
          Container(
            color: backgroundColor,
            width: double.infinity,
            child: Column(
              mainAxisAlignment:
                  widget.mainAxisAlignment ?? MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Opacity(
                  opacity: widget.isDisabled ? 0.5 : 1,
                  child: widget.iconData == null
                      ? isOnlineIcon
                          ? SvgPicture.network(
                              widget.iconPath,
                              height: widget.assetSize ?? 140,
                              width: widget.assetSize ?? 140,
                            )
                          : SvgPicture.asset(
                              widget.iconPath,
                              height: widget.assetSize ?? 140,
                              width: widget.assetSize ?? 140,
                            )
                      : FaIcon(
                          widget.iconData,
                          size: widget.assetSize ?? 140,
                          color: widget.textColor.withOpacity(0.6),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 16),
                  child: Column(
                    children: [
                      if (widget.titleBig.isNotEmpty)
                        Text(
                          widget.titleBig,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: widget.isDisabled
                                        ? FamilyAppTheme.disabledTileBorder
                                        : widget.textColor,
                                  ),
                        )
                      else
                        const SizedBox(),
                      if (widget.titleSmall.isNotEmpty)
                        Text(
                          widget.titleSmall,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: widget.isDisabled
                                        ? FamilyAppTheme.disabledTileBorder
                                        : widget.textColor,
                                  ),
                        )
                      else
                        const SizedBox(),
                      SizedBox(height: widget.subtitle.isNotEmpty ? 8 : 0),
                      if (widget.subtitle.isNotEmpty)
                        Text(
                          widget.subtitle,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: widget.textColor.withAlpha(200),
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
          if (widget.isSelected)
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
