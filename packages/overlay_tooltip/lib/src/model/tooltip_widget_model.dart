import 'package:flutter/cupertino.dart';
import 'package:overlay_tooltip/src/constants/enums.dart';
import 'package:overlay_tooltip/src/impl.dart';

class OverlayTooltipModel {

  OverlayTooltipModel(
      {required this.absorbPointer,
      required this.child,
      required this.tooltip,
      required this.widgetKey,
      required this.vertPosition,
      required this.horPosition,
      required this.displayIndex,
      this.onHighlightedWidgetTap,});
  final bool absorbPointer;
  final Widget child;
  final Widget Function(TooltipController) tooltip;
  final GlobalKey widgetKey;
  final TooltipVerticalPosition vertPosition;
  final TooltipHorizontalPosition horPosition;
  final int displayIndex;
  final VoidCallback? onHighlightedWidgetTap;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverlayTooltipModel &&
          runtimeType == other.runtimeType &&
          displayIndex == other.displayIndex;

  @override
  int get hashCode => displayIndex.hashCode;

  @override
  String toString() {
    return 'displayIndex: $displayIndex';
  }
}
