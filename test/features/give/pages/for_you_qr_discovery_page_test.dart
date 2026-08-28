import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/shared/models/collect_group.dart';

void main() {
  const collectGroup = CollectGroup(
    nameSpace: '61f7ed014e4c0620d000',
    orgName: 'Test church',
    hasCelebration: false,
    type: CollectGroupType.church,
  );

  const scannedInstance = '61f7ed014e4c0620d000.c00000000004';

  group('ForYouQrDiscoveryPage inactive QR continue', () {
    test(
      'Yes please navigates with namespace-only list giving context',
      () {
        const flowContext = ForYouFlowContext(
          source: ForYouEntrySource.qrCode,
          entryMediumId: scannedInstance,
        );

        final extra = flowContext
            .forGiveViaListAfterInactiveQr(collectGroup)
            .toMap();
        final navigated = ForYouFlowContext.fromMap(extra);

        expect(navigated.entryMediumId, collectGroup.nameSpace);
        expect(navigated.entryMediumId, isNot(equals(scannedInstance)));
        expect(navigated.giveViaListOnly, isTrue);
        expect(navigated.restrictToEntryQrGoal, isFalse);
        expect(
          navigated.selectedOrganisation?.nameSpace,
          collectGroup.nameSpace,
        );
      },
    );
  });
}
