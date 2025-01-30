import 'package:flutter/cupertino.dart';
import 'package:overlay_tooltip/src/constants/enums.dart';
import '../impl.dart';

class OverlayTooltipModel {
  final bool absorbPointer;
  final Widget child;
  final Widget Function(TooltipController) tooltip;
  final GlobalKey widgetKey;
  final TooltipVerticalPosition vertPosition;
  final TooltipHorizontalPosition horPosition;
  final int displayIndex;

  OverlayTooltipModel(
      {required this.absorbPointer,
      required this.child,
      required this.tooltip,
      required this.widgetKey,
      required this.vertPosition,
      required this.horPosition,
      required this.displayIndex});

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
