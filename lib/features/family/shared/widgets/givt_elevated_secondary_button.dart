import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/custom_progress_indicator.dart';

class GivtElevatedSecondaryButton extends StatefulWidget {
  const GivtElevatedSecondaryButton({
    super.key,
    this.isDisabled,
    required this.onTap,
    required this.text,
    this.isLoading,
    this.leftIcon,
    this.rightIcon,
    this.leadingImage,
    this.widthMultiplier = .9,
  });

  final VoidCallback? onTap;
  final bool? isDisabled;
  final String text;
  final bool? isLoading;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Widget? leadingImage;
  final double widthMultiplier;

  @override
  State<GivtElevatedSecondaryButton> createState() =>
      _GivtElevatedSecondaryButtonState();
}

class _GivtElevatedSecondaryButtonState
    extends State<GivtElevatedSecondaryButton> {
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
      dropShadowHeight = 2;
      paddingtop = 4;
    } else {
      dropShadowHeight = 4;
      paddingtop = 2;
    }

    return Padding(
      padding: EdgeInsets.only(top: widget.isDisabled == true ? 4 : paddingtop),
      child: GestureDetector(
        onTap: widget.isDisabled == true
            ? null
            : () async {
                await Future.delayed(const Duration(milliseconds: 50));
                widget.onTap?.call();
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
                await Future.delayed(const Duration(milliseconds: 50));
                HapticFeedback.lightImpact();
                setState(() {
                  isPressed = false;
                });
              },
        onTapUp: widget.isDisabled == true
            ? null
            : (details) async {
                await Future.delayed(const Duration(milliseconds: 50));
                HapticFeedback.lightImpact();
                setState(() {
                  isPressed = false;
                });
              },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primaryContainer,
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: widget.isDisabled == true ? 0 : dropShadowHeight,
            right: 2,
            left: 2,
            top: 2,
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width * widget.widthMultiplier,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.isDisabled == true
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : Colors.white,
            ),
            child: getChild(),
          ),
        ),
      ),
    );
  }

  Widget getChild() {
    if (widget.isLoading == true) {
      return const CustomCircularProgressIndicator();
    }
    if (widget.leftIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: widget.leftIcon,
          ),
          Text(
            widget.text,
            style: widget.isDisabled == true
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline)
                : Theme.of(context).textTheme.labelMedium,
          ),
        ],
      );
    }
    if (widget.rightIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: widget.isDisabled == true
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline)
                : Theme.of(context).textTheme.labelMedium,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: widget.leftIcon,
          ),
        ],
      );
    }
    if (widget.leadingImage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.leadingImage!,
            Text(
              widget.text,
              style: widget.isDisabled == true
                  ? Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.outline)
                  : Theme.of(context).textTheme.labelMedium,
            ),
            // all leading images must be 32 pixels wide
            // this centers the text
            const SizedBox(width: 32),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        widget.text,
        style: widget.isDisabled == true
            ? Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline)
            : Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}
