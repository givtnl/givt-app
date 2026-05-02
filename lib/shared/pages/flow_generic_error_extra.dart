import 'package:flutter/material.dart';

/// Arguments for [FlowGenericErrorPage] (via `GoRouterState.extra`).
class FlowGenericErrorExtra {
  const FlowGenericErrorExtra({
    required this.screenTitle,
    required this.title,
    required this.message,
    required this.errorReason,
    required this.onTryAgain,
    required this.onGoHome,
  });

  /// Shown in the app bar (e.g. mandate flow vs other flows).
  final String screenTitle;

  final String title;
  final String message;

  /// Included in support contact metadata (e.g. `conflict`, `failure`).
  final String errorReason;

  /// Typically: clear flow state + pop this route.
  final VoidCallback onTryAgain;

  /// Typically: clear flow state + navigate home.
  final VoidCallback onGoHome;
}
