import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/shared/models/collect_group.dart';

void main() {
  const collectGroup = CollectGroup(
    nameSpace: '61f7ed014e4c0620d000',
    orgName: 'Test org',
    hasCelebration: false,
    type: CollectGroupType.church,
  );

  group('ForYouFlowContext.forGiveViaListAfterInactiveQr', () {
    test(
      'uses organisation namespace and list-only giving',
      () {
        const scannedInstance = '61f7ed014e4c0620d000.c00000000004';
        const current = ForYouFlowContext(
          source: ForYouEntrySource.qrCode,
          entryMediumId: scannedInstance,
          restrictToEntryQrGoal: true,
        );

        final continued = current.forGiveViaListAfterInactiveQr(collectGroup);

        expect(continued.entryMediumId, collectGroup.nameSpace);
        expect(continued.entryMediumId, isNot(contains('.')));
        expect(continued.giveViaListOnly, isTrue);
        expect(continued.restrictToEntryQrGoal, isFalse);
        expect(continued.selectedOrganisation, collectGroup);
        expect(continued.source, ForYouEntrySource.qrCode);
      },
    );

    test('round-trips giveViaListOnly through toMap/fromMap', () {
      final original = const ForYouFlowContext(
        source: ForYouEntrySource.qrCode,
      ).forGiveViaListAfterInactiveQr(collectGroup);

      final restored = ForYouFlowContext.fromMap(original.toMap());

      expect(restored.giveViaListOnly, isTrue);
      expect(restored.entryMediumId, collectGroup.nameSpace);
      expect(restored.restrictToEntryQrGoal, isFalse);
      expect(restored.selectedOrganisation?.nameSpace, collectGroup.nameSpace);
    });
  });
}
