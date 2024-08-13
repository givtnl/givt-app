import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class BodySmallText extends StatelessWidget {
  // when color is not defined it will default to primary20
  const BodySmallText(
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
  });

  factory BodySmallText.primary30(String text) =>
      BodySmallText(text, color: FamilyAppTheme.primary30);

  factory BodySmallText.primary40(String text) =>
      BodySmallText(text, color: FamilyAppTheme.primary40);

  factory BodySmallText.secondary20(String text) =>
      BodySmallText(text, color: FamilyAppTheme.secondary20);

  factory BodySmallText.secondary30(String text) =>
      BodySmallText(text, color: FamilyAppTheme.secondary30);

  factory BodySmallText.secondary40(String text) =>
      BodySmallText(text, color: FamilyAppTheme.secondary40);

  factory BodySmallText.tertiary20(String text) =>
      BodySmallText(text, color: FamilyAppTheme.tertiary20);

  factory BodySmallText.tertiary40(String text) =>
      BodySmallText(text, color: FamilyAppTheme.tertiary40);

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
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
    );
  }
}
