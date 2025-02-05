import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_small_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FunProgressbar extends StatefulWidget {
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
    EdgeInsets? margin,
  }) {
    return FunProgressbar(
      currentProgress: currentProgress,
      total: total,
      prefixWidget: const Icon(
        Icons.bolt,
        color: FamilyAppTheme.highlight30,
      ),
      suffix: 'XP',
      margin: margin,
    );
  }

  factory FunProgressbar.powerstones({
    required int currentProgress,
    required int total,
    EdgeInsets? margin,
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
      margin: margin,
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
  State<FunProgressbar> createState() => _FunProgressbarState();
}

class _FunProgressbarState extends State<FunProgressbar> {
  bool checkForCompletion = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                height: 37,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ?? FamilyAppTheme.neutralVariant99,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              AnimatedContainer(
                onEnd: () => setState(() {
                  checkForCompletion = true;
                }),
                height: 37,
                width: constraints.maxWidth *
                    (widget.currentProgress / widget.total),
                decoration: BoxDecoration(
                  color: widget.progressColor ?? FamilyAppTheme.highlight90,
                  borderRadius: BorderRadius.circular(100),
                ),
                duration: const Duration(milliseconds: 300),
              ),
              Container(
                height: 37,
                alignment: Alignment.center,
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.prefixWidget != null) widget.prefixWidget!,
                      LabelSmallText(
                        '${widget.currentProgress} / ${widget.total}${widget.suffix == null ? '' : ' ${widget.suffix}'}',
                        color: widget.textColor ?? FamilyAppTheme.highlight30,
                      ),
                    ],
                  ),
                  secondChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelSmallText(
                        widget.completedText ?? 'Completed',
                        color: widget.textColor ?? FamilyAppTheme.highlight30,
                      ),
                    ],
                  ),
                  crossFadeState: checkForCompletion &&
                          widget.currentProgress >= widget.total
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
