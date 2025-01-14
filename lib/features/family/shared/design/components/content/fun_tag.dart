import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_small_text.dart';
import 'package:givt_app/shared/models/color_combo.dart';

class FunTag extends StatelessWidget {
  const FunTag({
    required this.text,
    this.colorCombo = ColorCombo.primary,
    super.key,
  });

  factory FunTag.gold({required String text}) {
    return FunTag(
      text: text,
      colorCombo: ColorCombo.highlight,
    );
  }

  factory FunTag.purple({required String text}) {
    return FunTag(
      text: text,
      colorCombo: ColorCombo.tertiary,
    );
  }
  factory FunTag.blue({required String text}) {
    return FunTag(
      text: text,
      colorCombo: ColorCombo.secondary,
    );
  }

  final ColorCombo colorCombo;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: colorCombo.accentColor,
      ),
      child: LabelSmallText(
        text,
        textAlign: TextAlign.center,
        color: colorCombo.textColor,
      ),
    );
  }
}
