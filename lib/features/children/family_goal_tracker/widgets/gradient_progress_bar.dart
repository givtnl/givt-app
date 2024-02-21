import 'package:flutter/material.dart';
import 'package:givt_app/utils/app_theme.dart';

class GradientProgressBar extends StatefulWidget {
  const GradientProgressBar({
    required this.colors,
    required this.progress,
    this.totalProgress,
    super.key,
  });
  final List<Color> colors;
  final double progress;
  final double? totalProgress;

  @override
  State<GradientProgressBar> createState() => _GradientProgressBarState();
}

class _GradientProgressBarState extends State<GradientProgressBar> {
  double _progress = 0;
  double _totalProgress = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _progress = widget.progress;
        _totalProgress = widget.totalProgress ?? widget.progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final widthToApply = availableWidth * _progress;
        final totalWidthToApply = availableWidth * _totalProgress;

        const barHeight = 12.0;
        return Container(
          height: barHeight,
          width: availableWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: widget.colors.map((e) => e.withOpacity(0.3)).toList(),
            ),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(seconds: 1),
                width: totalWidthToApply,
                height: barHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    constraints: const BoxConstraints.tightFor(
                      width: double.infinity,
                      height: 12,
                    ),
                    decoration: _gradientProgressBarDecoration(
                      [AppTheme.highlight80],
                      _progress,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(seconds: 1),
                width: widthToApply,
                height: barHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    constraints: const BoxConstraints.tightFor(
                      width: double.infinity,
                      height: 12,
                    ),
                    decoration: _gradientProgressBarDecoration(
                      widget.colors,
                      _progress,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _gradientProgressBarDecoration(
    List<Color> colors,
    double progress,
  ) {
    final colorsCount = (colors.length * progress).round();
    final colorsToApply = colors.sublist(0, colorsCount);
    if (colorsToApply.isEmpty) {
      return BoxDecoration(color: colors[0]);
    }
    if (colorsToApply.length < 2) colorsToApply.add(colors[0]);
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colorsToApply,
      ),
    );
  }
}
