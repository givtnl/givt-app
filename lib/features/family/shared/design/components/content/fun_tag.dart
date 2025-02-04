import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/areas.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/color_combo.dart';

// Which side of the tag should be flat (non-circular)
enum FlatSide { left, right, none }

class FunTag extends StatelessWidget {
  const FunTag({
    required this.text,
    required this.textColor,
    required this.accentColor,
    super.key,
    this.borderRadius,
    this.iconData,
    this.flatSide = FlatSide.none,
    this.iconSize,
  });

  factory FunTag.fromArea({
    required Areas area,
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
    double? iconSize,
  }) {
    return FunTag(
      text: text,
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
      area: tag.area,
      iconData: tag.iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.fromColorCombo({
    required ColorCombo combo,
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag(
      text: text,
      textColor: combo.textColor,
      accentColor: combo.accentColor,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.primary({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.fromColorCombo(
      combo: ColorCombo.primary,
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.green({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.primary(
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.highlight({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.fromColorCombo(
      combo: ColorCombo.highlight,
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.gold({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.highlight(
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.tertiary({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.fromColorCombo(
      combo: ColorCombo.tertiary,
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.purple({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.tertiary(
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.secondary({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.fromColorCombo(
      combo: ColorCombo.secondary,
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.blue({
    required String text,
    IconData? iconData,
    FlatSide flatSide = FlatSide.none,
  }) {
    return FunTag.secondary(
      text: text,
      iconData: iconData,
      flatSide: flatSide,
    );
  }

  factory FunTag.xp(int xp) {
    return FunTag.fromArea(
      area: Areas.highlight,
      text: '$xp XP',
      iconData: Icons.bolt,
      iconSize: 16,
    );
  }

  final String text;
  final Color textColor;
  final Color accentColor;
  final BorderRadius? borderRadius;
  final IconData? iconData;
  final FlatSide flatSide;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return tagContainer();
  }

  Container tagContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: borderRadius ?? _getBorderRadius(),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: flatSide == FlatSide.left ? 16 : 12,
          right: flatSide == FlatSide.right ? 16 : 12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null)
              Icon(
                iconData,
                color: textColor,
                size: iconSize,
              ),
            if (iconData != null) const SizedBox(width: 1.5),
            LabelSmallText(
              text,
              color: textColor,
            ),
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
