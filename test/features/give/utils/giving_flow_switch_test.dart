import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/utils/giving_flow_switch.dart';

void main() {
  group('GivingFlowSwitchDecision.resolve', () {
    test('keeps the switch and the current tab when the flag is off', () {
      final decision = GivingFlowSwitchDecision.resolve(
        hideSwitch: false,
        currentPageIndex: 0,
      );

      expect(decision.showSwitch, isTrue);
      expect(decision.pageIndex, 0);
    });

    test('keeps the current For You tab when the flag is off', () {
      final decision = GivingFlowSwitchDecision.resolve(
        hideSwitch: false,
        currentPageIndex: GivingFlowSwitchDecision.newFlowPageIndex,
      );

      expect(decision.showSwitch, isTrue);
      expect(decision.pageIndex, GivingFlowSwitchDecision.newFlowPageIndex);
    });

    test('hides the switch and shows For You when the flag is on', () {
      final decision = GivingFlowSwitchDecision.resolve(
        hideSwitch: true,
        currentPageIndex: 0,
      );

      expect(decision.showSwitch, isFalse);
      expect(decision.pageIndex, GivingFlowSwitchDecision.newFlowPageIndex);
    });
  });
}
