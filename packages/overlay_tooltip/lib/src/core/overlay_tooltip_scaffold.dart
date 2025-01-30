import 'dart:math';

import 'package:flutter/material.dart';
import 'package:overlay_tooltip/src/constants/enums.dart';
import 'package:overlay_tooltip/src/model/tooltip_widget_model.dart';
import 'package:overlay_tooltip/src/impl.dart';
import '../constants/extensions.dart';

abstract class OverlayTooltipScaffoldImpl extends StatefulWidget {
  final TooltipController controller;
  final Future<bool> Function(int instantiatedWidgetLength)? startWhen;
  final Widget Function(BuildContext context) builder;
  final Color overlayColor;
  final Duration tooltipAnimationDuration;
  final Curve tooltipAnimationCurve;
  final Widget? preferredOverlay;

  OverlayTooltipScaffoldImpl({
    Key? key,
    required this.controller,
    required this.builder,
    required this.overlayColor,
    required this.startWhen,
    required this.tooltipAnimationDuration,
    required this.tooltipAnimationCurve,
    this.preferredOverlay,
  }) : super(key: key) {
    if (startWhen != null) controller.setStartWhen(startWhen!);
  }

  @override
  State<OverlayTooltipScaffoldImpl> createState() =>
      OverlayTooltipScaffoldImplState();
}

class OverlayTooltipScaffoldImplState
    extends State<OverlayTooltipScaffoldImpl> {
  void addPlayableWidget(OverlayTooltipModel model) {
    widget.controller.addPlayableWidget(model);
  }

  TooltipController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Builder(builder: (context) {
            return widget.builder(context);
          })),
          StreamBuilder<OverlayTooltipModel?>(
            stream: widget.controller.widgetsPlayStream,
            builder: (context, snapshot) {
              return snapshot.data == null ||
                      snapshot.data!.widgetKey.globalPaintBounds == null
                  ? SizedBox.shrink()
                  : Positioned.fill(
                      child: Stack(
                        children: [
                          widget.preferredOverlay ??
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: widget.overlayColor,
                              ),
                          TweenAnimationBuilder(
                            key: ValueKey(snapshot.data!.displayIndex),
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: widget.tooltipAnimationDuration,
                            curve: widget.tooltipAnimationCurve,
                            builder: (_, double val, child) {
                              val = min(val, 1);
                              val = max(val, 0);
                              return Opacity(
                                opacity: val,
                                child: child,
                              );
                            },
                            child: _TooltipLayout(
                              model: snapshot.data!,
                              controller: widget.controller,
                            ),
                          ),
                        ],
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}

class _TooltipLayout extends StatelessWidget {
  final OverlayTooltipModel model;
  final TooltipController controller;

  const _TooltipLayout(
      {Key? key, required this.model, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var topLeft = model.widgetKey.globalPaintBounds!.topLeft;
    var bottomRight = model.widgetKey.globalPaintBounds!.bottomRight;

    return LayoutBuilder(builder: (context, size) {
      if (topLeft.dx < 0) {
        bottomRight = Offset(bottomRight.dx + (0 - topLeft.dx), bottomRight.dy);
        topLeft = Offset(0, topLeft.dy);
      }

      if (bottomRight.dx > size.maxWidth) {
        topLeft =
            Offset(topLeft.dx - (bottomRight.dx - size.maxWidth), topLeft.dy);
        bottomRight = Offset(size.maxWidth, bottomRight.dy);
      }

      if (topLeft.dy < 0) {
        bottomRight = Offset(bottomRight.dx, bottomRight.dy + (0 - topLeft.dy));
        topLeft = Offset(topLeft.dx, 0);
      }

      if (bottomRight.dy > size.maxHeight) {
        topLeft =
            Offset(topLeft.dx, topLeft.dy - (bottomRight.dy - size.maxHeight));
        bottomRight = Offset(bottomRight.dx, size.maxHeight);
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: topLeft.dy,
            left: topLeft.dx,
            bottom: size.maxHeight - bottomRight.dy,
            right: size.maxWidth - bottomRight.dx,
            child: AbsorbPointer(
                child: model.child, absorbing: model.absorbPointer),
          ),
          _buildToolTip(topLeft, bottomRight, size)
        ],
      );
    });
  }

  Widget _buildToolTip(
      Offset topLeft, Offset bottomRight, BoxConstraints size) {
    bool isTop = model.vertPosition == TooltipVerticalPosition.TOP;

    bool alignLeft = topLeft.dx <= (size.maxWidth - bottomRight.dx);

    final calculatedLeft = alignLeft ? topLeft.dx : null;
    final calculatedRight = alignLeft ? null : size.maxWidth - bottomRight.dx;
    final calculatedTop = isTop ? null : bottomRight.dy;
    final calculatedBottom = isTop ? (size.maxHeight - topLeft.dy) : null;
    return (model.horPosition == TooltipHorizontalPosition.WITH_WIDGET)
        ? Positioned(
            top: calculatedTop,
            left: calculatedLeft,
            right: calculatedRight,
            bottom: calculatedBottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                model.tooltip(controller),
              ],
            ),
          )
        : Positioned(
            top: calculatedTop,
            left: 0,
            right: 0,
            bottom: calculatedBottom,
            child: model.horPosition == TooltipHorizontalPosition.CENTER
                ? Center(
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      model.tooltip(controller),
                    ],
                  ))
                : Align(
                    alignment:
                        model.horPosition == TooltipHorizontalPosition.RIGHT
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        model.tooltip(controller),
                      ],
                    ),
                  ),
          );
  }
}
