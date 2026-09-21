import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

/// Zoom scale helpers for the For You QR scanner.
///
/// The camera zoom API uses a 0.0–1.0 scale (0 = fully zoomed out).
class QrScannerZoom {
  static const double minScale = 0;
  static const double maxScale = 1;
  static const double togglePreset = 0.35;
  static const double restThreshold = 0.05;
  static const double minDelta = 0.02;
  static const double pinchSensitivity = 0.5;

  static double clamp(double scale) => scale.clamp(minScale, maxScale);

  /// Maps a pinch [gestureScale] (1.0 at gesture start) onto camera zoom.
  static double fromPinch({
    required double startScale,
    required double gestureScale,
  }) {
    return clamp(startScale + (gestureScale - 1) * pinchSensitivity);
  }

  static bool shouldApply(double current, double next) {
    return (next - current).abs() >= minDelta;
  }

  static bool isAtRest(double scale) => scale < restThreshold;

  static double toggleTarget(double current) {
    return isAtRest(current) ? togglePreset : minScale;
  }
}

class QrScannerZoomButton extends StatelessWidget {
  const QrScannerZoomButton({
    required this.isZoomed,
    required this.semanticsLabel,
    required this.analyticsEvent,
    required this.onPressed,
    super.key,
  });

  final bool isZoomed;
  final String semanticsLabel;
  final AnalyticsEvent analyticsEvent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Material(
        color: theme.neutral100.withValues(alpha: 0.92),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            AnalyticsHelper.logEvent(
              eventName: analyticsEvent.name,
              eventProperties: analyticsEvent.parameters,
            );
            onPressed();
          },
          child: SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: FaIcon(
                isZoomed
                    ? FontAwesomeIcons.magnifyingGlassMinus
                    : FontAwesomeIcons.magnifyingGlassPlus,
                size: 22,
                color: theme.primary30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
