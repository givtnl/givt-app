import 'package:geolocator/geolocator.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

/// Resolver helpers for the "for you" discovery flows.
///
/// These helpers map QR / beacon / GPS inputs to a [CollectGroup] (org) so
/// we can directly open the existing amount+goals screen.
class ForYouDiscoveryResolvers {
  ForYouDiscoveryResolvers._();

  static Future<CollectGroup?> resolveCollectGroupFromQrMediumId(
    String mediumId, {
    CollectGroupRepository? collectGroupRepository,
  }) async {
    if (mediumId.isEmpty) return null;

    final repo = collectGroupRepository ?? getIt<CollectGroupRepository>();
    var collectGroups = await repo.getCollectGroupList();
    if (collectGroups.isEmpty) {
      collectGroups = await repo.fetchCollectGroupList();
    }

    if (!mediumId.contains('.')) return null;

    final namespace = mediumId.split('.').first;
    final instance = mediumId.split('.').last;

    final matchingQrCode = collectGroups
        .where((group) => group.nameSpace.startsWith(namespace))
        .expand((group) => group.qrCodes)
        .firstWhere(
          (qrCode) => qrCode.instance.endsWith(instance),
          orElse: () => const QrCode.empty(),
        );

    if (matchingQrCode.instance.isEmpty) return null;
    if (!matchingQrCode.isActive) return null;

    // Find the owning collect group for the active QR code.
    final matchingGroup = collectGroups.firstWhere(
      (group) =>
          group.nameSpace.startsWith(namespace) &&
          group.qrCodes.any(
            (qrCode) => qrCode.instance.endsWith(instance),
          ),
      orElse: () => const CollectGroup.empty(),
    );

    return matchingGroup.nameSpace.isEmpty ? null : matchingGroup;
  }

  static Future<CollectGroup?> resolveCollectGroupFromBeaconId(
    String beaconId, {
    CollectGroupRepository? collectGroupRepository,
  }) async {
    if (beaconId.isEmpty) return null;

    final repo = collectGroupRepository ?? getIt<CollectGroupRepository>();
    var collectGroups = await repo.getCollectGroupList();
    if (collectGroups.isEmpty) {
      collectGroups = await repo.fetchCollectGroupList();
    }

    // Fast path: match on namespace presence.
    final directMatch = collectGroups.firstWhere(
      (group) => beaconId.contains(group.nameSpace),
      orElse: () => const CollectGroup.empty(),
    );
    if (directMatch.nameSpace.isNotEmpty) return directMatch;

    if (!beaconId.contains('.')) return null;

    final namespace = beaconId.split('.').first;
    final fallbackMatch = collectGroups.firstWhere(
      (group) => group.nameSpace == namespace || group.nameSpace.startsWith(namespace),
      orElse: () => const CollectGroup.empty(),
    );

    return fallbackMatch.nameSpace.isEmpty ? null : fallbackMatch;
  }

  static Future<CollectGroup?> resolveNearestCollectGroup(
    double latitude,
    double longitude, {
    CollectGroupRepository? collectGroupRepository,
  }) async {
    final repo = collectGroupRepository ?? getIt<CollectGroupRepository>();
    var collectGroups = await repo.getCollectGroupList();
    if (collectGroups.isEmpty) {
      collectGroups = await repo.fetchCollectGroupList();
    }

    final locations = <Location>[];
    for (final group in collectGroups) {
      locations.addAll(group.locations);
    }

    Location? nearestLocation;
    for (final location in locations) {
      // Mirror the existing GPS discovery logic: only consider locations
      // with valid begin/end dates.
      if (location.end == null || location.begin == null) continue;

      final distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        latitude,
        longitude,
      );

      if (distance < location.radius) {
        if (nearestLocation == null) {
          nearestLocation = location;
          continue;
        }

        final distanceBetweenPrevious = Geolocator.distanceBetween(
          nearestLocation.latitude,
          nearestLocation.longitude,
          latitude,
          longitude,
        );

        if (distanceBetweenPrevious > distance) {
          nearestLocation = location;
        }
      }
    }

    if (nearestLocation == null || nearestLocation.beaconId.isEmpty) {
      return null;
    }

    return resolveCollectGroupFromBeaconId(
      nearestLocation.beaconId,
      collectGroupRepository: collectGroupRepository,
    );
  }
}

