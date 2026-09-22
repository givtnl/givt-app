import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/analytics_helper.dart';

/// Zoom scale helpers for the For You QR scanner.
///
/// The camera zoom API takes a 0.0–1.0 value. On Android that is CameraX linear
/// zoom: 0 is the widest lens and 1 is maximum digital zoom. A phone's
/// normal 1× view often sits well above 0, so the button steps up from the
/// opening zoom instead of aiming at a fixed point on that scale.
class QrScannerZoom {
  static const double minScale = 0;
  static const double maxScale = 1;

  /// How far the zoom button moves past the camera's opening zoom.
  ///
  /// A fixed target such as 0.4 is already below the 1× view on many Android
  /// phones, and treating that as "go to max" snaps to full digital zoom.
  static const double zoomInStep = 0.15;
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

  /// True when [scale] is within [restThreshold] of the camera's opening zoom.
  ///
  /// [opening] defaults to [minScale] so a camera that starts fully zoomed out
  /// keeps the previous rest check.
  static bool isAtRest(double scale, {double opening = minScale}) {
    return (scale - opening).abs() < restThreshold;
  }

  /// Steps [zoomInStep] past [opening], or returns to [opening] when zoomed.
  static double toggleTarget(double current, {double opening = minScale}) {
    if (!isAtRest(current, opening: opening)) {
      return opening;
    }
    return clamp(opening + zoomInStep);
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
