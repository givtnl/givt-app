import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_small_text.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/l10n/l10n.dart';

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
  })  : assert(currentProgress >= 0, 'Current progress must be non-negative'),
        assert(total > 0, 'Total must be greater than zero');

  factory FunProgressbar.gratitudeGoal({
    required int currentProgress,
    required int total,
    required String suffix,
    EdgeInsets? margin,
    Key? key,
  }) {
    return FunProgressbar(
      key: key,
      currentProgress: currentProgress,
      total: total,
      prefixWidget: const Padding(
        padding: EdgeInsets.only(right: 4),
        child: FaIcon(
          FontAwesomeIcons.fire,
          color: FamilyAppTheme.highlight30,
          size: 12,
        ),
      ),
      suffix: suffix,
      margin: margin,
    );
  }

  factory FunProgressbar.generosityHunt({
    required int currentProgress,
    required int total,
    required String suffix,
    EdgeInsets? margin,
    Key? key,
  }) {
    return FunProgressbar(
      key: key,
      currentProgress: currentProgress,
      total: total,
      prefixWidget: const Padding(
        padding: EdgeInsets.only(right: 4),
        child: FaIcon(
          FontAwesomeIcons.hourglassEnd,
          color: FamilyAppTheme.highlight30,
          size: 12,
        ),
      ),
      suffix: suffix,
      margin: margin,
    );
  }

  factory FunProgressbar.powerstones({
    required int currentProgress,
    required int total,
    EdgeInsets? margin,
    Key? key,
  }) {
    return FunProgressbar(
      key: key,
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
  void didUpdateWidget(FunProgressbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentProgress != widget.currentProgress) {
      setState(() {
        checkForCompletion = false;
      });
    } else {
      setState(() {
        checkForCompletion = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
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
              if (widget.currentProgress >= 0 && widget.total > 0)
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
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                ),
              Container(
                height: 37,
                alignment: Alignment.center,
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstCurve: Curves.easeOut,
                  secondCurve: Curves.easeOut,
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
                        widget.completedText ?? context.l10n.completedKey,
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
