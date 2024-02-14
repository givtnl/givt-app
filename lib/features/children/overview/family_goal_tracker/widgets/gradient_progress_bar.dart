import 'dart:developer';

import 'package:flutter/material.dart';

class GradientProgressBar extends StatefulWidget {
  const GradientProgressBar({
    required this.colors,
    required this.progress,
    super.key,
  });
  final List<Color> colors;
  final double progress;

  @override
  State<GradientProgressBar> createState() => _GradientProgressBarState();
}

class _GradientProgressBarState extends State<GradientProgressBar> {
  double _progress = 0.0;

  @override
  void didUpdateWidget(GradientProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final widtthToApply = availableWidth * _progress;

        return Container(
          height: 12,
          width: availableWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: widget.colors.map((e) => e.withOpacity(0.3)).toList(),
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(seconds: 1),
                width: widtthToApply,
                height: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: _GradientProgressBarInternal(
                    widget.colors,
                    _progress,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GradientProgressBarInternal extends StatelessWidget {
  const _GradientProgressBarInternal(this.colors, this.value);
  static const double _kLinearProgressIndicatorHeight = 12;
  final List<Color> colors;
  final double value;

  @override
  Widget build(BuildContext context) {
    final colorsCount = (colors.length * value).toInt();
    final colorsToApply = colors.sublist(0, colorsCount);
    if (colorsToApply.isEmpty) {
      return Container();
    }
    if (colorsToApply.length < 2) colorsToApply.add(colors[0]);
    for (var i = 0; i < colorsToApply.length; i++) {
      log('colorsToApply[$i]: ${colorsToApply[i]}');
    }
    return Container(
      constraints: const BoxConstraints.tightFor(
        width: double.infinity,
        height: _kLinearProgressIndicatorHeight,
      ),
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: colorsToApply)),
    );
  }
}



// SKETCH

//  return Stack(
//           children: <Widget>[
//             Container(
//               width: constraints.maxWidth,
//               height: 10,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: widget.colors.map((e) => e.withOpacity(0.3)).toList(),
//                 ),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//             FractionallySizedBox(
//               alignment: Alignment.centerLeft,
//               widthFactor: _progress,
//               child: Container(
//                 height: 10,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: widget.colors,
//                   ),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//             ),
//           ],
//         );

