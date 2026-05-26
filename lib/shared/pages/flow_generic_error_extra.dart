import 'package:flutter/material.dart';

/// Arguments for the shared flow error screen (via `GoRouterState.extra`).
class FlowGenericErrorExtra {
  const FlowGenericErrorExtra({
    required this.errorReason,
    required this.onDismiss,
    required this.onTryAgain,
    this.supportFlow = 'Onboarding',
    this.supportMetadata = const {},
  });

  /// Technical error code for support (e.g. `conflict`, `failure`).
  final String errorReason;

  /// Flow label sent with support contact metadata.
  final String supportFlow;

  /// Extra key/value pairs appended to the support email (e.g. country, status).
  final Map<String, String> supportMetadata;

  /// Clears flow error state when the screen is dismissed (any route).
  final VoidCallback onDismiss;

  /// Returns the user to the previous step to retry.
  final VoidCallback onTryAgain;
}
