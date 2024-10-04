import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class TitleLargeText extends StatelessWidget {
  // when color is not defined it will default to primary20
  const TitleLargeText(
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
    this.shadows,
  });

  factory TitleLargeText.primary30(String text) =>
      TitleLargeText(text, color: FamilyAppTheme.primary30);

  factory TitleLargeText.primary40(String text) =>
      TitleLargeText(text, color: FamilyAppTheme.primary40);

  factory TitleLargeText.secondary20(String text) =>
      TitleLargeText(text, color: FamilyAppTheme.secondary20);

  factory TitleLargeText.secondary30(String text) =>
      TitleLargeText(text, color: FamilyAppTheme.secondary30);

  factory TitleLargeText.secondary40(String text) =>
      TitleLargeText(text, color: FamilyAppTheme.secondary40);

  factory TitleLargeText.tertiary20(String text) =>
      TitleLargeText(text, color: FamilyAppTheme.tertiary20);

  factory TitleLargeText.tertiary40(String text) =>
      TitleLargeText(text, color: FamilyAppTheme.tertiary40);

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
  final List<Shadow>? shadows;

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
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: color, shadows: shadows),
    );
  }
}
