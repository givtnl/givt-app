import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/family_text_styles.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class HeadlineLargeText extends StatelessWidget {
  // when color is not defined it will default to primary20
  const HeadlineLargeText(
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

  factory HeadlineLargeText.primary30(String text) =>
      HeadlineLargeText(text, color: FamilyAppTheme.primary30);

  factory HeadlineLargeText.primary40(String text) =>
      HeadlineLargeText(text, color: FamilyAppTheme.primary40);

  factory HeadlineLargeText.secondary20(String text) =>
      HeadlineLargeText(text, color: FamilyAppTheme.secondary20);

  factory HeadlineLargeText.secondary30(String text) =>
      HeadlineLargeText(text, color: FamilyAppTheme.secondary30);

  factory HeadlineLargeText.secondary40(String text) =>
      HeadlineLargeText(text, color: FamilyAppTheme.secondary40);

  factory HeadlineLargeText.tertiary20(String text) =>
      HeadlineLargeText(text, color: FamilyAppTheme.tertiary20);

  factory HeadlineLargeText.tertiary40(String text) =>
      HeadlineLargeText(text, color: FamilyAppTheme.tertiary40);

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
      style: FamilyTextStyles.headlineLarge.copyWith(color: color),
    );
  }
}
