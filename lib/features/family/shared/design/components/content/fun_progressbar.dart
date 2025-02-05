import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_small_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunProgressbar extends StatelessWidget {
  const FunProgressbar({
    required this.currentProgress,
    required this.total,
    super.key,
    this.prefixWidget,
    this.suffix,
    this.completedText,
    this.margin,
    this.backgroundColor,
    this.progressColor,
    this.textColor,
  });

  factory FunProgressbar.xp({
    required int currentProgress,
    required int total,
  }) {
    return FunProgressbar(
      currentProgress: currentProgress,
      total: total,
      prefixWidget: const Icon(
        Icons.bolt,
        color: FamilyAppTheme.highlight30,
      ),
      suffix: 'XP',
    );
  }

  factory FunProgressbar.powerstones({
    required int currentProgress,
    required int total,
  }) {
    return FunProgressbar(
      currentProgress: currentProgress,
      total: total,
      prefixWidget: const Icon(
        Icons.water_drop,
        color: FamilyAppTheme.secondary30,
      ),
      textColor: FamilyAppTheme.secondary30,
      progressColor: FamilyAppTheme.secondary95,
    );
  }

  // Widget to show before the progress (i.e. a bolt icon or a powerstone etc)
  final Widget? prefixWidget;

  // The current amount of progress achieved
  final int currentProgress;

  // The total amount of progress that can be achieved before teh goa
  final int total;

  // Text to show after the progress (i.e. XP or HP etc)
  final String? suffix;

  // Text to show when currentAmount >= total
  final String? completedText;

  final EdgeInsets? margin;

  final Color? backgroundColor;
  final Color? progressColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: backgroundColor ?? FamilyAppTheme.neutralVariant99,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              AnimatedContainer(
                width: constraints.maxWidth * (currentProgress / total),
                decoration: BoxDecoration(
                  color: progressColor ?? FamilyAppTheme.highlight90,
                  borderRadius: BorderRadius.circular(100),
                ),
                duration: const Duration(milliseconds: 300),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixWidget != null) prefixWidget!,
                    LabelSmallText(
                      '$currentProgress / $total${suffix == null ? '' : ' $suffix'}',
                      color: textColor ?? FamilyAppTheme.highlight30,
                    ),
                  ],
                ),
                secondChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabelSmallText(
                      completedText ?? 'Completed',
                      color: textColor ?? FamilyAppTheme.highlight30,
                    ),
                  ],
                ),
                crossFadeState: currentProgress < total
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ],
          );
        },
      ),
    );
  }
}
