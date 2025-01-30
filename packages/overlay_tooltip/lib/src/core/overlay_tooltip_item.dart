import 'package:flutter/material.dart';
import '../constants/enums.dart';
import '../impl.dart';
import '../model/tooltip_widget_model.dart';

abstract class OverlayTooltipItemImpl extends StatefulWidget {
  final bool absorbPointer;
  final Widget child;
  final Widget Function(TooltipController) tooltip;
  final TooltipVerticalPosition tooltipVerticalPosition;
  final TooltipHorizontalPosition tooltipHorizontalPosition;
  final int displayIndex;

  OverlayTooltipItemImpl(
      {Key? key,
      required this.absorbPointer,
      required this.displayIndex,
      required this.child,
      required this.tooltip,
      required this.tooltipVerticalPosition,
      required this.tooltipHorizontalPosition})
      : super(key: key);

  @override
  _OverlayTooltipItemImplState createState() => _OverlayTooltipItemImplState();
}

class _OverlayTooltipItemImplState extends State<OverlayTooltipItemImpl> {
  final GlobalKey widgetKey = GlobalKey();

  @override
  void didUpdateWidget(covariant OverlayTooltipItemImpl oldWidget) {
    _addToPlayableWidget();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _addToPlayableWidget();
    super.initState();
  }

  void _addToPlayableWidget() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        OverlayTooltipScaffold.of(context)?.addPlayableWidget(
            OverlayTooltipModel(
                absorbPointer: widget.absorbPointer,
                child: widget.child,
                tooltip: widget.tooltip,
                widgetKey: widgetKey,
                vertPosition: widget.tooltipVerticalPosition,
                horPosition: widget.tooltipHorizontalPosition,
                displayIndex: widget.displayIndex));
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: widgetKey,
      color: Colors.transparent,
      child: widget.child,
    );
  }
}
