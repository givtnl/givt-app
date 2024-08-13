import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class LabelSmallText extends StatelessWidget {
  // when color is not defined it will default to primary20
  const LabelSmallText(
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

  factory LabelSmallText.primary30(String text) =>
      LabelSmallText(text, color: FamilyAppTheme.primary30);

  factory LabelSmallText.primary40(String text) =>
      LabelSmallText(text, color: FamilyAppTheme.primary40);

  factory LabelSmallText.secondary20(String text) =>
      LabelSmallText(text, color: FamilyAppTheme.secondary20);

  factory LabelSmallText.secondary30(String text) =>
      LabelSmallText(text, color: FamilyAppTheme.secondary30);

  factory LabelSmallText.secondary40(String text) =>
      LabelSmallText(text, color: FamilyAppTheme.secondary40);

  factory LabelSmallText.tertiary20(String text) =>
      LabelSmallText(text, color: FamilyAppTheme.tertiary20);

  factory LabelSmallText.tertiary40(String text) =>
      LabelSmallText(text, color: FamilyAppTheme.tertiary40);

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
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
    );
  }
}
