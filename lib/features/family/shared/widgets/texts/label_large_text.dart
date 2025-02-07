import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class LabelLargeText extends StatelessWidget {
  // when color is not defined it will default to primary20
  const LabelLargeText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.semanticsLabel,
    this.overflow,
    this.textDirection,
    this.locale,
    this.textHeightBehavior,
    this.softWrap,
    this.textScaler,
    this.selectionColor,
    this.textWidthBasis,
    this.strutStyle,
    this.fontFeatures,
  });

  factory LabelLargeText.primary30(String text) =>
      LabelLargeText(text, color: FamilyAppTheme.primary30);

  factory LabelLargeText.primary40(String text,
          {List<FontFeature>? fontFeatures}) =>
      LabelLargeText(
        text,
        color: FamilyAppTheme.primary40,
        fontFeatures: fontFeatures,
      );

  factory LabelLargeText.secondary20(String text) =>
      LabelLargeText(text, color: FamilyAppTheme.secondary20);

  factory LabelLargeText.secondary30(String text) =>
      LabelLargeText(text, color: FamilyAppTheme.secondary30);

  factory LabelLargeText.secondary40(String text) =>
      LabelLargeText(text, color: FamilyAppTheme.secondary40);

  factory LabelLargeText.tertiary20(String text) =>
      LabelLargeText(text, color: FamilyAppTheme.tertiary20);

  factory LabelLargeText.tertiary40(String text) =>
      LabelLargeText(text, color: FamilyAppTheme.tertiary40);

  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final String? semanticsLabel;
  final TextOverflow? overflow;
  final TextDirection? textDirection;
  final Locale? locale;
  final TextHeightBehavior? textHeightBehavior;
  final bool? softWrap;
  final TextScaler? textScaler;
  final Color? selectionColor;
  final TextWidthBasis? textWidthBasis;
  final StrutStyle? strutStyle;
  final List<FontFeature>? fontFeatures;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      overflow: overflow,
      textDirection: textDirection,
      locale: locale,
      textHeightBehavior: textHeightBehavior,
      softWrap: softWrap,
      textScaler: textScaler,
      selectionColor: selectionColor,
      textWidthBasis: textWidthBasis,
      strutStyle: strutStyle,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontFeatures: fontFeatures,
          ),
    );
  }
}
