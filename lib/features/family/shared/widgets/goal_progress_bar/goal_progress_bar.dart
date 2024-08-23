import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/impact_groups/model/goal.dart';
import 'package:givt_app/features/family/shared/widgets/goal_progress_bar/goal_progress_bar_label.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class GoalProgressBar extends StatefulWidget {
  const GoalProgressBar({
    required this.goal,
    this.colors = _defaultColors,
    this.showFlag = false,
    this.showGoalLabel = false,
    this.showCurrentLabel = false,
    this.goalLabelBackgroundColor = FamilyAppTheme.primary95,
    this.currentLabelBackgroundColor = FamilyAppTheme.secondary98,
    super.key,
  });

  final Goal goal;
  final List<Color> colors;
  final Color goalLabelBackgroundColor;
  final Color currentLabelBackgroundColor;

  final bool showFlag;
  final bool showGoalLabel;
  final bool showCurrentLabel;

  static const _defaultColors = [
    FamilyAppTheme.highlight90,
    FamilyAppTheme.progressGradient1,
    FamilyAppTheme.progressGradient2,
    FamilyAppTheme.progressGradient3,
    FamilyAppTheme.primary70,
  ];

  @override
  State<GoalProgressBar> createState() => _GoalProgressBarState();
}

class _GoalProgressBarState extends State<GoalProgressBar> {
  double _progress = 0;
  double _totalProgress = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        final progress = widget.goal.amount / widget.goal.goalAmount.toDouble();
        _progress = progress > 1 ? 1 : progress;
        final totalProgress =
            widget.goal.totalAmount / widget.goal.goalAmount.toDouble();
        _totalProgress = totalProgress > 1 ? 1 : totalProgress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const barHeight = 12.0;

        final availableWidth = constraints.maxWidth;
        final widthToApply = availableWidth * _progress < barHeight
            ? barHeight
            : availableWidth * _progress;
        final totalWidthToApply = availableWidth * _totalProgress;

        const currentLabelOffsetY = 38.0;

        final isCompleted = widget.goal.amount >= widget.goal.goalAmount;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showCurrentLabel)
              isCompleted
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          const Spacer(),
                          GoalProgressBarLabel(
                            text: 'Completed!',
                            backgroundColor: widget.currentLabelBackgroundColor,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(height: currentLabelOffsetY),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.showCurrentLabel && !isCompleted)
                  Positioned(
                    left: widthToApply,
                    top: -currentLabelOffsetY,
                    child: GoalProgressBarLabel.amount(
                      widget.goal.amount.toInt(),
                      backgroundColor: widget.currentLabelBackgroundColor,
                      isCenterAnchor: true,
                    ),
                  ),
                Container(
                  height: barHeight,
                  width: availableWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors:
                          widget.colors.map((e) => e.withOpacity(0.3)).toList(),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: const Duration(seconds: 1),
                        width: totalWidthToApply,
                        height: barHeight,
                        child: Container(
                          constraints: const BoxConstraints.tightFor(
                            width: double.infinity,
                            height: 12,
                          ),
                          decoration: _gradientProgressBarDecoration(
                            widget.colors
                                .map((e) => e.withOpacity(0.4))
                                .toList(),
                            _totalProgress,
                            false,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: const Duration(seconds: 1),
                        width: widthToApply,
                        height: barHeight,
                        child: Container(
                          constraints: const BoxConstraints.tightFor(
                            width: double.infinity,
                            height: 12,
                          ),
                          decoration: _gradientProgressBarDecoration(
                            widget.colors,
                            _progress,
                            true,
                          ),
                        ),
                      ),
                      if (widget.showFlag && !isCompleted)
                        Positioned(
                          top: -19,
                          right: -1,
                          child: SvgPicture.asset(
                            'assets/family/images/goal_flag.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.showGoalLabel)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  children: [
                    const Spacer(),
                    GoalProgressBarLabel.amount(
                      widget.goal.goalAmount,
                      backgroundColor: widget.goalLabelBackgroundColor,
                      isBold: true,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  BoxDecoration _gradientProgressBarDecoration(
    List<Color> colors,
    double progress,
    bool whiteShadow,
  ) {
    final colorsCount = (colors.length * progress).round();
    final colorsToApply = colors.sublist(0, colorsCount);
    if (colorsToApply.isEmpty) {
      return BoxDecoration(
        border: Border.all(
          color: Colors.white,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(5),
        color: colors[0],
      );
    }
    if (colorsToApply.length < 2) colorsToApply.add(colors[0]);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: whiteShadow
          ? Border.all(
              color: Colors.white,
              strokeAlign: BorderSide.strokeAlignOutside,
            )
          : null,
      gradient: LinearGradient(
        colors: colorsToApply,
      ),
    );
  }
}
