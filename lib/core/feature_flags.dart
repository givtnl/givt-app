/// PostHog feature flag keys used in the Givt EU app.
abstract final class FeatureFlags {
  static const String showPledges = 'show_pledges';

  /// Hides the home tabs that switch between the old give flow and For You,
  /// and keeps the user on For You. Off by default, so current behaviour stays
  /// until PostHog enables the flag.
  static const String hideGivingFlowSwitch = 'hide_giving_flow_switch';
}
