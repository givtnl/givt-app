import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/utils/app_theme.dart';

class ActionContainer extends StatefulWidget {
  const ActionContainer({
    required this.borderColor,
    required this.onTap,
    required this.child,
    this.isDisabled = false,
    this.isSelected = false,
    this.isPressedDown = false,
    this.isMuted = false,
    this.base = ActionContainerBase.bottom,
    this.margin,
    this.borderSize = 2,
    this.baseBorderSize = 6,
    this.onTapCancel,
    this.onTapDown,
    this.onTapUp,
    super.key,
  });
  final VoidCallback? onTap;
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapDown;
  final bool isDisabled;
  final bool isSelected;
  final bool isPressedDown;
  final bool isMuted;
  final Color borderColor;
  final ActionContainerBase base;
  final Widget child;
  final EdgeInsets? margin;
  final double borderSize;
  final double baseBorderSize;

  @override
  State<ActionContainer> createState() => _ActionContainerState();
}

class _ActionContainerState extends State<ActionContainer> {
  Color? borderColor;

  Future<void> _actionDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 30));
  }

  bool _isManualPressed = false;

  bool get _isPressed {
    return _isManualPressed ||
        widget.isDisabled ||
        widget.isSelected ||
        widget.isPressedDown;
  }

  void _setManualPressed(bool value) {
    if (mounted) {
      setState(() {
        _isManualPressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    borderColor =
        widget.isDisabled ? AppTheme.givtGraycece : widget.borderColor;
    return widget.isDisabled
        ? _buildContainer(widget.child)
        : GestureDetector(
            onTap: () async {
              widget.onTap?.call();
              await _actionDelay();
            },
            onTapDown: (details) {
              widget.onTapDown?.call();
              if (!widget.isMuted) {
                SystemSound.play(SystemSoundType.click);
              }
              _setManualPressed(true);
            },
            onTapCancel: () {
              widget.onTapCancel?.call();
              _unpress();
            },
            onTapUp: (details) {
              widget.onTapUp?.call();
              _unpress();
            },
            child: _buildContainer(widget.child),
          );
  }

  Future<void> _unpress() async {
    await _actionDelay();
    if (!widget.isMuted) {
      await HapticFeedback.lightImpact();
    }
    _setManualPressed(false);
  }

  EdgeInsets? _getOpositeMarginByBase(ActionContainerBase base) {
    if (!_isPressed) {
      return null;
    }
    final opositeMargin = widget.baseBorderSize - widget.borderSize;
    var margin = EdgeInsets.zero;
    if (base.isLeft) margin += EdgeInsets.only(right: opositeMargin);
    if (base.isTop) margin += EdgeInsets.only(bottom: opositeMargin);
    if (base.isRight) margin += EdgeInsets.only(left: opositeMargin);
    if (base.isBottom) margin += EdgeInsets.only(top: opositeMargin);
    return margin;
  }

  BorderSide _getBorderSize({
    required bool isBaseSide,
  }) {
    return BorderSide(
      color: borderColor!,
      width:
          isBaseSide && !_isPressed ? widget.baseBorderSize : widget.borderSize,
    );
  }

  Border _getBorderByBase(ActionContainerBase base) {
    return Border(
      bottom: _getBorderSize(isBaseSide: base.isBottom),
      right: _getBorderSize(isBaseSide: base.isRight),
      left: _getBorderSize(isBaseSide: base.isLeft),
      top: _getBorderSize(isBaseSide: base.isTop),
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      margin: widget.margin,
      child: Container(
        margin: _getOpositeMarginByBase(widget.base),
        decoration: BoxDecoration(
          color: borderColor,
          border: _getBorderByBase(widget.base),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: child,
        ),
      ),
    );
  }
}

enum ActionContainerBase {
  left,
  top,
  right,
  bottom,
  leftTop,
  rightTop,
  rightBottom,
  leftBottom;

  bool get isLeft => this == left || this == leftTop || this == leftBottom;

  bool get isRight => this == right || this == rightTop || this == rightBottom;

  bool get isTop => this == top || this == leftTop || this == rightTop;

  bool get isBottom =>
      this == bottom || this == leftBottom || this == rightBottom;
}
