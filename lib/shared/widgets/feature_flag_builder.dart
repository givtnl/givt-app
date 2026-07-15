import 'package:flutter/material.dart';
import 'package:givt_app/utils/analytics_helper.dart';

/// Builds [builder] only when [featureFlagKey] is enabled in PostHog.
///
/// When the flag cannot be evaluated, [fallback] is used (defaults to false).
class FeatureFlagBuilder extends StatefulWidget {
  const FeatureFlagBuilder({
    required this.featureFlagKey,
    required this.builder,
    this.fallback = false,
    super.key,
  });

  final String featureFlagKey;
  final bool fallback;
  final Widget Function(BuildContext context, bool isEnabled) builder;

  @override
  State<FeatureFlagBuilder> createState() => _FeatureFlagBuilderState();
}

class _FeatureFlagBuilderState extends State<FeatureFlagBuilder> {
  late Future<bool> _isEnabledFuture;

  @override
  void initState() {
    super.initState();
    _isEnabledFuture = _loadFlag();
  }

  Future<bool> _loadFlag() async {
    await AnalyticsHelper.ensureInitialized();
    return AnalyticsHelper.isFeatureEnabled(
      widget.featureFlagKey,
      fallback: widget.fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isEnabledFuture,
      builder: (context, snapshot) {
        final isEnabled = snapshot.data ?? widget.fallback;
        return widget.builder(context, isEnabled);
      },
    );
  }
}
