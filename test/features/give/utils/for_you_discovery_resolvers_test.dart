import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/give/utils/for_you_discovery_resolvers.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

class FakeCollectGroupRepository with CollectGroupRepository {
  FakeCollectGroupRepository(this._groups);

  final List<CollectGroup> _groups;

  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async => _groups;

  @override
  Future<List<CollectGroup>> getCollectGroupList() async => _groups;
}

void main() {
  group('ForYouDiscoveryResolvers', () {
    test(
      'resolveCollectGroupFromQrMediumId returns active matching group',
      () async {
        final group = CollectGroup(
          nameSpace: 'abc',
          orgName: 'Org A',
          hasCelebration: false,
          type: CollectGroupType.church,
          qrCodes: [
            QrCode(
              name: 'Instance name',
              instance: 'abc.def',
              isActive: true,
            ),
          ],
        );

        final repo = FakeCollectGroupRepository([group]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupFromQrMediumId(
              'abc.def',
              collectGroupRepository: repo,
            );

        expect(result, isNotNull);
        expect(result?.nameSpace, equals('abc'));
        expect(result?.orgName, equals('Org A'));
      },
    );

    test(
      'resolveCollectGroupAndQrFromQrMediumId resolves namespace-only mediumId',
      () async {
        final group = CollectGroup(
          nameSpace: '61f7ed014e4c0621d000',
          orgName: 'Namespace Org',
          hasCelebration: false,
          type: CollectGroupType.church,
          qrCodes: [
            QrCode(
              name: '',
              instance: '61f7ed014e4c0621d000.generic',
              isActive: true,
            ),
          ],
        );

        final repo = FakeCollectGroupRepository([group]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
              '61f7ed014e4c0621d000',
              collectGroupRepository: repo,
            );

        expect(result.isSuccess, isTrue);
        expect(result.collectGroup?.nameSpace, equals('61f7ed014e4c0621d000'));
        expect(result.qrCode?.isGeneric, isTrue);
      },
    );

    test(
      'resolveCollectGroupAndQrFromQrMediumId does not match longer namespace by prefix',
      () async {
        final longerNamespaceGroup = CollectGroup(
          nameSpace: '61f7ed014e4c0621d0009',
          orgName: 'Longer Org',
          hasCelebration: false,
          type: CollectGroupType.church,
          qrCodes: [
            QrCode(
              name: '',
              instance: '61f7ed014e4c0621d0009.generic',
              isActive: true,
            ),
          ],
        );

        final repo = FakeCollectGroupRepository([longerNamespaceGroup]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
              '61f7ed014e4c0621d000',
              collectGroupRepository: repo,
            );

        expect(result.isSuccess, isFalse);
        expect(result.failure, equals(ForYouDiscoveryFailure.notFound));
      },
    );

    test(
      'resolveCollectGroupAndQrFromQrMediumId prefers exact namespace match',
      () async {
        final prefixGroup = CollectGroup(
          nameSpace: '61f7ed014e4c0621d000',
          orgName: 'Prefix Org',
          hasCelebration: false,
          type: CollectGroupType.church,
        );
        final exactGroup = CollectGroup(
          nameSpace: '61f7ed014e4c0621d0009',
          orgName: 'Exact Org',
          hasCelebration: false,
          type: CollectGroupType.church,
          qrCodes: [
            QrCode(
              name: '',
              instance: '61f7ed014e4c0621d0009.generic',
              isActive: true,
            ),
          ],
        );

        final repo = FakeCollectGroupRepository([prefixGroup, exactGroup]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
              '61f7ed014e4c0621d0009',
              collectGroupRepository: repo,
            );

        expect(result.isSuccess, isTrue);
        expect(result.collectGroup?.orgName, equals('Exact Org'));
      },
    );

    test(
      'resolveCollectGroupAndQrFromQrMediumId returns inactiveQrCode for inactive generic QR',
      () async {
        final group = CollectGroup(
          nameSpace: '61f7ed014e4c0621d000',
          orgName: 'Namespace Org',
          hasCelebration: false,
          type: CollectGroupType.church,
          qrCodes: [
            QrCode(
              name: '',
              instance: '61f7ed014e4c0621d000.generic',
              isActive: false,
            ),
          ],
        );

        final repo = FakeCollectGroupRepository([group]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
              '61f7ed014e4c0621d000',
              collectGroupRepository: repo,
            );

        expect(result.isSuccess, isFalse);
        expect(result.failure, equals(ForYouDiscoveryFailure.inactiveQrCode));
      },
    );

    test(
      'resolveCollectGroupAndQrFromQrMediumId resolves dotted mediumId',
      () async {
        final group = CollectGroup(
          nameSpace: '61f7ed014e4c0424c000',
          orgName: 'Dotted Org',
          hasCelebration: false,
          type: CollectGroupType.church,
          qrCodes: [
            QrCode(
              name: 'Goal',
              instance: '61f7ed014e4c0424c000.c00000000001',
              isActive: true,
            ),
          ],
        );

        final repo = FakeCollectGroupRepository([group]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
              '61f7ed014e4c0424c000.c00000000001',
              collectGroupRepository: repo,
            );

        expect(result.isSuccess, isTrue);
        expect(result.collectGroup?.nameSpace, equals('61f7ed014e4c0424c000'));
        expect(result.qrCode?.instance, endsWith('c00000000001'));
      },
    );

    test(
      'resolveCollectGroupAndQrFromQrMediumId returns notFound for unknown mediumId',
      () async {
        final group = CollectGroup(
          nameSpace: 'known',
          orgName: 'Known Org',
          hasCelebration: false,
          type: CollectGroupType.church,
        );

        final repo = FakeCollectGroupRepository([group]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupAndQrFromQrMediumId(
              'unknown-medium-id',
              collectGroupRepository: repo,
            );

        expect(result.isSuccess, isFalse);
        expect(result.failure, equals(ForYouDiscoveryFailure.notFound));
      },
    );

    test(
      'resolveCollectGroupFromQrMediumId returns null for inactive QR',
      () async {
        final group = CollectGroup(
          nameSpace: 'abc',
          orgName: 'Org A',
          hasCelebration: false,
          type: CollectGroupType.church,
          qrCodes: [
            QrCode(
              name: 'Instance name',
              instance: 'abc.def',
              isActive: false,
            ),
          ],
        );

        final repo = FakeCollectGroupRepository([group]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupFromQrMediumId(
              'abc.def',
              collectGroupRepository: repo,
            );

        expect(result, isNull);
      },
    );

    test(
      'resolveCollectGroupFromBeaconId matches by namespace presence',
      () async {
        const group = CollectGroup(
          nameSpace: 'abc',
          orgName: 'Org A',
          hasCelebration: false,
          type: CollectGroupType.charities,
        );

        final repo = FakeCollectGroupRepository([group]);
        final result =
            await ForYouDiscoveryResolvers.resolveCollectGroupFromBeaconId(
              'abc.1234',
              collectGroupRepository: repo,
            );

        expect(result, isNotNull);
        expect(result!.nameSpace, equals('abc'));
      },
    );

    test(
      'resolveNearbyCollectGroups returns nearest location within radius',
      () async {
        final now = DateTime.now();

        final groupA = CollectGroup(
          nameSpace: 'a',
          orgName: 'Org A',
          hasCelebration: false,
          type: CollectGroupType.church,
          locations: [
            Location(
              name: 'Loc A',
              latitude: 0,
              longitude: 0,
              radius: 200,
              beaconId: 'a.1',
              begin: now,
              end: null, // should be skipped
            ),
            Location(
              name: 'Loc A2',
              latitude: 0,
              longitude: 0,
              radius: 5000,
              beaconId: 'a.2',
              begin: now,
              end: null, // should be skipped
            ),
          ],
        );

        // We need begin/end set for candidates.
        final groupB = CollectGroup(
          nameSpace: 'b',
          orgName: 'Org B',
          hasCelebration: false,
          type: CollectGroupType.church,
          locations: [
            Location(
              name: 'Loc B1',
              latitude: 0,
              longitude: 0,
              radius: 5000,
              beaconId: 'b.1',
              begin: now,
              end: now.add(const Duration(days: 1)),
            ),
            Location(
              name: 'Loc B2',
              latitude: 0.01,
              longitude: 0,
              radius: 5000,
              beaconId: 'b.2',
              begin: now,
              end: now.add(const Duration(days: 1)),
            ),
          ],
        );

        // Target is closer to B1 than B2.
        final targetLat = 0.001;
        final targetLng = 0.0;
        final repo = FakeCollectGroupRepository([groupA, groupB]);

        final distanceToB1 = Geolocator.distanceBetween(
          groupB.locations[0].latitude,
          groupB.locations[0].longitude,
          targetLat,
          targetLng,
        );
        final distanceToB2 = Geolocator.distanceBetween(
          groupB.locations[1].latitude,
          groupB.locations[1].longitude,
          targetLat,
          targetLng,
        );

        expect(distanceToB1, lessThan(distanceToB2));

        final result =
            await ForYouDiscoveryResolvers.resolveNearbyCollectGroups(
              targetLat,
              targetLng,
              collectGroupRepository: repo,
            );

        expect(result, isNotEmpty);
        expect(result.first.nameSpace, equals('b'));
        expect(result.first.orgName, equals('Org B'));
      },
    );
  });
}
