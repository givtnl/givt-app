import 'package:flutter/material.dart';
import 'core/overlay_tooltip_scaffold.dart';
import 'constants/enums.dart';
import 'core/tooltip_controller.dart';
import 'core/overlay_tooltip_item.dart';

class TooltipController extends TooltipControllerImpl {}

class OverlayTooltipScaffold extends OverlayTooltipScaffoldImpl {
  final TooltipController controller;

  /// This future boolean function exposes the amount of instantiated
  /// widgets with tooltips, this future bool functions tells the overlay
  /// when to start automatically
  final Future<bool> Function(int instantiatedWidgetLength)? startWhen;

  final Widget Function(BuildContext context) builder;

  final Color overlayColor;

  final Duration tooltipAnimationDuration;

  final Curve tooltipAnimationCurve;

  // Set a preferred overlay widget.
  // This can be useful for gesture detection on your custom overlays
  final Widget? preferredOverlay;

  OverlayTooltipScaffold({
    Key? key,
    required this.controller,
    required this.builder,
    this.overlayColor = Colors.black54,
    this.startWhen,
    this.tooltipAnimationDuration = const Duration(milliseconds: 500),
    this.tooltipAnimationCurve = Curves.decelerate,
    this.preferredOverlay,
  }) : super(
          key: key,
          controller: controller,
          builder: builder,
          overlayColor: overlayColor,
          startWhen: startWhen,
          tooltipAnimationDuration: tooltipAnimationDuration,
          tooltipAnimationCurve: tooltipAnimationCurve,
          preferredOverlay: preferredOverlay,
        );

  static OverlayTooltipScaffoldImplState? of(BuildContext context) {
    final OverlayTooltipScaffoldImplState? result =
        context.findAncestorStateOfType<OverlayTooltipScaffoldImplState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'OverlayTooltipScaffold.of() called with a context that does not contain a OverlayTooltipScaffold.',
      ),
      ErrorDescription(
        'No OverlayTooltipScaffold ancestor could be found starting from the context that was passed to OverlayTooltipScaffold.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the OverlayTooltipScaffold widget being sought.',
      ),
      context.describeElement('The context used was'),
    ]);
  }
}

class OverlayTooltipItem extends OverlayTooltipItemImpl {
  final bool absorbPointer;

  final Widget child;

  /// The tooltip widget to be displayed with the main widget
  final Widget Function(TooltipController) tooltip;

  /// The vertical positioning of the tooltip with relation to the widget
  /// [BOTTOM] or [TOP]
  final TooltipVerticalPosition tooltipVerticalPosition;

  /// The horizontal positioning of the tooltip
  /// [WITH_WIDGET] default, this aligns the tooltip to the alignment
  /// of the main widget.
  /// Other options are [LEFT], [RIGHT], [CENTER]
  final TooltipHorizontalPosition tooltipHorizontalPosition;

  /// This determines the order of display when overlay is started
  final int displayIndex;

  OverlayTooltipItem(
      {Key? key,
      this.absorbPointer = true,
      required this.displayIndex,
      required this.child,
      required this.tooltip,
      this.tooltipVerticalPosition = TooltipVerticalPosition.BOTTOM,
      this.tooltipHorizontalPosition = TooltipHorizontalPosition.WITH_WIDGET})
      : super(
            key: key,
            absorbPointer: absorbPointer,
            child: child,
            displayIndex: displayIndex,
            tooltip: tooltip,
            tooltipVerticalPosition: tooltipVerticalPosition,
            tooltipHorizontalPosition: tooltipHorizontalPosition);
}
