import 'package:geolocator/geolocator.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

enum ForYouDiscoveryFailure {
  notFound,
  inactiveQrCode,
  inactiveCollectGroup,
}

class ForYouDiscoveryResult {
  const ForYouDiscoveryResult._({
    this.collectGroup,
    this.qrCode,
    this.failure,
  });

  const factory ForYouDiscoveryResult.success({
    required CollectGroup collectGroup,
    required QrCode qrCode,
  }) = _ForYouDiscoverySuccess;

  const factory ForYouDiscoveryResult.failure(
    ForYouDiscoveryFailure failure, {
    CollectGroup? collectGroup,
    QrCode? qrCode,
  }) = _ForYouDiscoveryFailure;

  final CollectGroup? collectGroup;
  final QrCode? qrCode;
  final ForYouDiscoveryFailure? failure;

  bool get isSuccess =>
      collectGroup != null && qrCode != null && failure == null;
}

class _ForYouDiscoverySuccess extends ForYouDiscoveryResult {
  const _ForYouDiscoverySuccess({
    required CollectGroup collectGroup,
    required QrCode qrCode,
  }) : super._(collectGroup: collectGroup, qrCode: qrCode);
}

class _ForYouDiscoveryFailure extends ForYouDiscoveryResult {
  const _ForYouDiscoveryFailure(
    ForYouDiscoveryFailure failure, {
    CollectGroup? collectGroup,
    QrCode? qrCode,
  }) : super._(
         failure: failure,
         collectGroup: collectGroup,
         qrCode: qrCode,
       );
}

/// Resolver helpers for the "for you" discovery flows.
///
/// These helpers map QR / beacon / GPS inputs to a [CollectGroup] (org) so
/// we can directly open the existing amount+goals screen.
class ForYouDiscoveryResolvers {
  ForYouDiscoveryResolvers._();

  static Future<ForYouDiscoveryResult> resolveCollectGroupAndQrFromQrMediumId(
    String mediumId, {
    CollectGroupRepository? collectGroupRepository,
  }) async {
    if (mediumId.isEmpty) {
      return const ForYouDiscoveryResult.failure(
        ForYouDiscoveryFailure.notFound,
      );
    }

    final repo = collectGroupRepository ?? getIt<CollectGroupRepository>();
    var collectGroups = await repo.getCollectGroupList();
    if (collectGroups.isEmpty) {
      collectGroups = await repo.fetchCollectGroupList();
    }

    if (!mediumId.contains('.')) {
      return const ForYouDiscoveryResult.failure(
        ForYouDiscoveryFailure.notFound,
      );
    }

    final namespace = mediumId.split('.').first;
    final instance = mediumId.split('.').last;

    // Find the owning collect group for the QR code instance.
    final matchingGroup = collectGroups.firstWhere(
      (group) =>
          group.nameSpace.startsWith(namespace) &&
          group.qrCodes.any(
            (qrCode) => qrCode.instance.endsWith(instance),
          ),
      orElse: () => const CollectGroup.empty(),
    );

    if (matchingGroup.nameSpace.isEmpty) {
      return const ForYouDiscoveryResult.failure(
        ForYouDiscoveryFailure.notFound,
      );
    }

    final matchingQrCode = matchingGroup.qrCodes.firstWhere(
      (qrCode) => qrCode.instance.endsWith(instance),
      orElse: () => const QrCode.empty(),
    );

    if (matchingQrCode.instance.isEmpty) {
      return const ForYouDiscoveryResult.failure(
        ForYouDiscoveryFailure.notFound,
      );
    }

    if (!matchingGroup.isActive) {
      return ForYouDiscoveryResult.failure(
        ForYouDiscoveryFailure.inactiveCollectGroup,
        collectGroup: matchingGroup,
      );
    }

    if (!matchingQrCode.isActive) {
      return ForYouDiscoveryResult.failure(
        ForYouDiscoveryFailure.inactiveQrCode,
        collectGroup: matchingGroup,
        qrCode: matchingQrCode,
      );
    }

    return ForYouDiscoveryResult.success(
      collectGroup: matchingGroup,
      qrCode: matchingQrCode,
    );
  }

  static Future<CollectGroup?> resolveCollectGroupFromQrMediumId(
    String mediumId, {
    CollectGroupRepository? collectGroupRepository,
  }) async {
    final resolved = await resolveCollectGroupAndQrFromQrMediumId(
      mediumId,
      collectGroupRepository: collectGroupRepository,
    );
    if (!resolved.isSuccess) {
      return null;
    }
    return resolved.collectGroup;
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
      (group) =>
          group.nameSpace == namespace || group.nameSpace.startsWith(namespace),
      orElse: () => const CollectGroup.empty(),
    );

    return fallbackMatch.nameSpace.isEmpty ? null : fallbackMatch;
  }

  /// Resolves all [CollectGroup]s within range of the user's location.
  /// Returns a list of organizations found at the nearest distance.
  /// If no organizations are found, returns an empty list.
  static Future<List<CollectGroup>> resolveNearbyCollectGroups(
    double latitude,
    double longitude, {
    CollectGroupRepository? collectGroupRepository,
  }) async {
    final hits = await resolveNearbyCollectGroupHits(
      latitude,
      longitude,
      collectGroupRepository: collectGroupRepository,
    );
    return hits.map((h) => h.collectGroup).toList();
  }

  /// Resolves the nearest collect group(s) within range, including the specific
  /// medium id (`Location.beaconId`) that matched.
  ///
  /// When multiple organisations are found at the same nearest distance, one
  /// hit per organisation is returned.
  static Future<List<({CollectGroup collectGroup, String beaconId})>>
  resolveNearbyCollectGroupHits(
    double latitude,
    double longitude, {
    CollectGroupRepository? collectGroupRepository,
  }) async {
    final repo = collectGroupRepository ?? getIt<CollectGroupRepository>();
    var collectGroups = await repo.getCollectGroupList();
    if (collectGroups.isEmpty) {
      collectGroups = await repo.fetchCollectGroupList();
    }

    // Map each location to its beacon ID and the collect group it belongs to
    final locationToGroupMap = <String, CollectGroup>{};
    for (final group in collectGroups) {
      for (final location in group.locations) {
        if (location.beaconId.isNotEmpty) {
          locationToGroupMap[location.beaconId] = group;
        }
      }
    }

    // Find all locations within range and calculate distances
    final withinRangeLocations = <Location, double>{};
    for (final group in collectGroups) {
      for (final location in group.locations) {
        // Only consider locations with valid begin/end dates
        if (location.end == null || location.begin == null) continue;

        final distance = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          latitude,
          longitude,
        );

        if (distance < location.radius) {
          withinRangeLocations[location] = distance;
        }
      }
    }

    if (withinRangeLocations.isEmpty) {
      return const [];
    }

    // Find the minimum distance
    final minDistance = withinRangeLocations.values.reduce(
      (a, b) => a < b ? a : b,
    );

    // Get all locations at the minimum distance (allowing small tolerance for floating point)
    const tolerance = 1.0; // 1 meter tolerance
    final nearestLocations = withinRangeLocations.entries
        .where((entry) => (entry.value - minDistance).abs() < tolerance)
        .map((entry) => entry.key)
        .toList();

    // Get unique collect groups for the nearest locations
    final uniqueHits =
        <String, ({CollectGroup collectGroup, String beaconId})>{};
    for (final location in nearestLocations) {
      if (location.beaconId.isNotEmpty) {
        final group = locationToGroupMap[location.beaconId];
        if (group != null) {
          uniqueHits[group.nameSpace] = (
            collectGroup: group,
            beaconId: location.beaconId,
          );
        }
      }
    }

    return uniqueHits.values.toList();
  }
}
