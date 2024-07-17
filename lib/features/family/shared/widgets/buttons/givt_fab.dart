import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GivtFloatingActionButton extends StatefulWidget {
  const GivtFloatingActionButton({
    super.key,
    this.isDisabled,
    required this.onTap,
    required this.text,
    this.leftIcon,
    this.rightIcon,
  });

  final VoidCallback onTap;
  final bool? isDisabled;
  final String text;
  final IconData? leftIcon;
  final IconData? rightIcon;

  @override
  State<GivtFloatingActionButton> createState() =>
      _GivtFloatingActionButtonState();
}

class _GivtFloatingActionButtonState extends State<GivtFloatingActionButton> {
  double dropShadowHeight = 4;
  double paddingtop = 4;
  bool isPressed = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDisabled == true || isPressed == true) {
      dropShadowHeight = 0;
      paddingtop = 4;
    } else {
      dropShadowHeight = 4;
      paddingtop = 0;
    }
    return Padding(
      padding: EdgeInsets.only(top: paddingtop),
      child: GestureDetector(
        onTap: widget.isDisabled == true
            ? null
            : () async {
                await Future<void>.delayed(const Duration(milliseconds: 100));
                widget.onTap();
              },
        onTapDown: widget.isDisabled == true
            ? null
            : (details) {
                SystemSound.play(SystemSoundType.click);
                setState(() {
                  isPressed = true;
                });
              },
        onTapCancel: widget.isDisabled == true
            ? null
            : () async {
                await Future<void>.delayed(const Duration(milliseconds: 50));
                unawaited(HapticFeedback.lightImpact());
                setState(() {
                  isPressed = false;
                });
              },
        onTapUp: widget.isDisabled == true
            ? null
            : (details) async {
                await Future<void>.delayed(const Duration(milliseconds: 50));
                unawaited(HapticFeedback.lightImpact());
                setState(() {
                  isPressed = false;
                });
              },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary,
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.only(bottom: dropShadowHeight),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: getChild(),
          ),
        ),
      ),
    );
  }

  Widget getChild() {
    if (widget.leftIcon != null) {
      return Padding(
        // 14 padding right is intentional from design to sizually balance the button
        padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                widget.leftIcon,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              widget.text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      );
    }
    if (widget.rightIcon != null) {
      return Padding(
        // 14 padding right is intentional from design to sizually balance the button
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.text,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                widget.rightIcon,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        widget.text,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
