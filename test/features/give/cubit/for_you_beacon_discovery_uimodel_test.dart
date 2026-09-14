// Manual QA (physical device): Android — BT scan+connect, off + turn-on flow,
// 30s scan cycles; location permission denied, approximate-only, GPS off, then
// grant + resume from Settings (searching UI must not flash while location is
// still blocked); iOS — Bluetooth permission denied then fixed in Settings (no
// location prompt); beacon seen but org not in list keeps searching without
// leaving the screen; after a beacon is found, app resume must not restart BLE
// scan during processingBeaconData.

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

    test('location phases are distinct from bluetooth and searching', () {
      const searching = ForYouBeaconDiscoveryUIModel(
        phase: ForYouBeaconDiscoveryPhase.searching,
      );
      const locationOff = ForYouBeaconDiscoveryUIModel(
        phase: ForYouBeaconDiscoveryPhase.locationOff,
      );
      const locationPermission = ForYouBeaconDiscoveryUIModel(
        phase: ForYouBeaconDiscoveryPhase.locationPermissionSettings,
      );
      const bluetoothOff = ForYouBeaconDiscoveryUIModel(
        phase: ForYouBeaconDiscoveryPhase.bluetoothOff,
      );

      expect(locationOff, isNot(equals(searching)));
      expect(locationOff, isNot(equals(locationPermission)));
      expect(locationOff, isNot(equals(bluetoothOff)));
      expect(locationPermission, isNot(equals(searching)));
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
