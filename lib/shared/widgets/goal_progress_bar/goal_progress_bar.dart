import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/impact_groups/models/goal.dart';
import 'package:givt_app/shared/widgets/goal_progress_bar/goal_progress_bar_label.dart';
import 'package:givt_app/utils/utils.dart';

class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({
    required this.goal,
    this.colors = _defaultColors,
    this.showFlag = false,
    this.showGoalLabel = false,
    this.showCurrentLabel = false,
    this.goalLabelBackgroundColor = AppTheme.primary95,
    this.currentLabelBackgroundColor = AppTheme.secondary98,
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
    AppTheme.highlight90,
    AppTheme.progressGradient1,
    AppTheme.progressGradient2,
    AppTheme.progressGradient3,
    AppTheme.primary70,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const barHeight = 12.0;
        final isCompleted = goal.amount >= goal.goalAmount;

        final progress = goal.amount / goal.goalAmount.toDouble();
        final _progress = progress > 1.0 ? 1.0 : progress;
        final totalProgress = goal.totalAmount / goal.goalAmount.toDouble();
        final _totalProgress = totalProgress > 1.0 ? 1.0 : totalProgress;

        final availableWidth = constraints.maxWidth;
        final widthToApply = availableWidth * _progress < barHeight
            ? barHeight
            : availableWidth * _progress;
        final totalWidthToApply = availableWidth * _totalProgress;

        const currentLabelOffsetY = 38.0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCurrentLabel)
              isCompleted
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          const Spacer(),
                          GoalProgressBarLabel(
                            //TODO: POEditor
                            text: 'Completed!',
                            backgroundColor: currentLabelBackgroundColor,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(height: currentLabelOffsetY),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (showCurrentLabel && !isCompleted)
                  Positioned(
                    left: widthToApply,
                    top: -currentLabelOffsetY,
                    child: GoalProgressBarLabel.amount(
                      goal.amount.toInt(),
                      backgroundColor: currentLabelBackgroundColor,
                      isCenterAnchor: true,
                    ),
                  ),
                Container(
                  height: barHeight,
                  width: availableWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      colors: colors.map((e) => e.withOpacity(0.3)).toList(),
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
                            colors.map((e) => e.withOpacity(0.4)).toList(),
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
                            colors,
                            _progress,
                            true,
                          ),
                        ),
                      ),
                      if (showFlag && !isCompleted)
                        Positioned(
                          top: -19,
                          right: -1,
                          child: SvgPicture.asset(
                            'assets/images/goal_flag_small.svg',
                            width: 24,
                            height: 24,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (showGoalLabel)
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  children: [
                    const Spacer(),
                    GoalProgressBarLabel.amount(
                      goal.goalAmount,
                      backgroundColor: goalLabelBackgroundColor,
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
            color: Colors.white, strokeAlign: BorderSide.strokeAlignOutside),
        borderRadius: BorderRadius.circular(5),
        color: colors[0],
      );
    }
    if (colorsToApply.length < 2) colorsToApply.add(colors[0]);
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: whiteShadow
          ? Border.all(
              color: Colors.white, strokeAlign: BorderSide.strokeAlignOutside)
          : null,
      gradient: LinearGradient(
        colors: colorsToApply,
      ),
    );
  }
}
