/// How the home giving-flow switch behaves for one PostHog flag value.
///
/// The flag defaults to off, which keeps the switch and the current tab.
/// When the flag is on, the old flow is not reachable: the switch is hidden
/// and For You (page 1) is shown. Opening home always starts on For You;
/// a switch to the old flow is not stored.
class GivingFlowSwitchDecision {
  const GivingFlowSwitchDecision({
    required this.showSwitch,
    required this.pageIndex,
  });

  factory GivingFlowSwitchDecision.resolve({
    required bool hideSwitch,
    required int currentPageIndex,
  }) {
    if (hideSwitch) {
      return const GivingFlowSwitchDecision(
        showSwitch: false,
        pageIndex: newFlowPageIndex,
      );
    }
    return GivingFlowSwitchDecision(
      showSwitch: true,
      pageIndex: currentPageIndex,
    );
  }

  /// Page index of the new For You flow.
  static const int newFlowPageIndex = 1;

  final bool showSwitch;
  final int pageIndex;
}
