import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/utils/utils.dart';

class GivtElevatedSecondaryButton extends StatefulWidget {
  const GivtElevatedSecondaryButton({
    required this.onTap,
    required this.text,
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.leadingImage,
    this.isLoading = false,
    this.isDisabled = false,
    this.widthMultiplier = .9,
    this.amplitudeEvent,
  });

  final VoidCallback? onTap;
  final bool isDisabled;
  final String text;
  final bool isLoading;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Widget? leadingImage;
  final double widthMultiplier;
  final AmplitudeEvents? amplitudeEvent;

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
    if (widget.isDisabled || isPressed) {
      dropShadowHeight = 2;
      paddingtop = 4;
    } else {
      dropShadowHeight = 4;
      paddingtop = 2;
    }
    final theme = const FamilyAppTheme().toThemeData();
    return Padding(
      padding: EdgeInsets.only(top: widget.isDisabled ? 4 : paddingtop),
      child: GestureDetector(
        onTap: widget.isDisabled
            ? null
            : () async {
                if (widget.amplitudeEvent != null) {
                  await AnalyticsHelper.logEvent(
                    eventName: widget.amplitudeEvent!,
                  );
                }

                await Future<void>.delayed(const Duration(milliseconds: 50));
                widget.onTap?.call();
              },
        onTapDown: widget.isDisabled
            ? null
            : (details) {
                SystemSound.play(SystemSoundType.click);
                setState(() {
                  isPressed = true;
                });
              },
        onTapCancel: widget.isDisabled
            ? null
            : () async {
                await Future<void>.delayed(const Duration(milliseconds: 50));
                unawaited(HapticFeedback.lightImpact());
                setState(() {
                  isPressed = false;
                });
              },
        onTapUp: widget.isDisabled
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
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color:
                    widget.isDisabled ? Colors.white : FamilyAppTheme.primary80,
              ),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: widget.isDisabled ? 0 : dropShadowHeight,
            right: 2,
            left: 2,
            top: 2,
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width * widget.widthMultiplier,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: getChild(theme),
          ),
        ),
      ),
    );
  }

  Widget getChild(ThemeData theme) {
    if (widget.isLoading) {
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
            style: widget.isDisabled
                ? theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  )
                : theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primary30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
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
            style: widget.isDisabled
                ? theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  )
                : theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primary30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rouna',
                  ),
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
              style: widget.isDisabled
                  ? theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    )
                  : theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primary30,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    ),
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
        style: widget.isDisabled
            ? theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rouna',
              )
            : theme.textTheme.labelLarge?.copyWith(
                color: AppTheme.primary30,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rouna',
              ),
      ),
    );
  }
}
