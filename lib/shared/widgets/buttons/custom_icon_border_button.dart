import 'package:flutter/material.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/color_combo.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

class CustomIconBorderButton extends StatelessWidget {
  const CustomIconBorderButton({
    required this.child,
    required this.onTap,
    required this.analyticsEvent,
    this.onTapCancel,
    this.onTapUp,
    this.onTapDown,
    this.isMuted = false,
    super.key,
  });
  final VoidCallback? onTap;
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapDown;
  final bool isMuted;
  final Widget child;
  final AnalyticsEvent analyticsEvent;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      onTap: onTap,
      onTapCancel: onTapCancel,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      isMuted: isMuted,
      borderColor: ColorCombo.primary.borderColor,
      baseBorderSize: 4,
      analyticsEvent: analyticsEvent,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: child,
      ),
    );
  }
}
