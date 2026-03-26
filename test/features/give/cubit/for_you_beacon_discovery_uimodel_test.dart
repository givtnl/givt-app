// Manual QA (physical device): Android — BT scan+connect, off + turn-on flow,
// 30s scan cycles; iOS — Bluetooth permission denied then fixed in Settings;
// beacon seen but org not in list keeps searching without leaving the screen.

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/cubit/for_you_beacon_discovery_custom.dart';
import 'package:givt_app/features/give/cubit/for_you_beacon_discovery_uimodel.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';

void main() {
  group('ForYouBeaconDiscoveryUIModel', () {
    test('props distinguish phases', () {
      const a = ForYouBeaconDiscoveryUIModel(
        phase: ForYouBeaconDiscoveryPhase.searching,
      );
      const b = ForYouBeaconDiscoveryUIModel(
        phase: ForYouBeaconDiscoveryPhase.bluetoothOff,
      );
      expect(a, equals(a));
      expect(a, isNot(equals(b)));
    });
  });

  group('ForYouBeaconDiscoveryCustom', () {
    test('NavigateToConfirm carries flow context', () {
      const flow = ForYouFlowContext(
        source: ForYouEntrySource.location,
      );
      const custom = ForYouBeaconNavigateToConfirm(flow);
      expect(custom.flowContext, flow);
    });

    test('NavigateToList carries flow context', () {
      const flow = ForYouFlowContext(
        source: ForYouEntrySource.search,
      );
      const custom = ForYouBeaconNavigateToList(flow);
      expect(custom.flowContext, flow);
    });
  });
}
