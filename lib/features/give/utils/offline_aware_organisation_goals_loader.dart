import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';

/// Loads organisation goals for giving, without blocking on a dead network.
///
/// The HTTP client waits 30s for a response. When the user has just gone
/// offline, [NetworkInfo.isConnected] can still be true for a moment, so a
/// short timeout is used as a fallback.
class OfflineAwareOrganisationGoalsLoader {
  const OfflineAwareOrganisationGoalsLoader({
    required OrganisationGoalsRepository repository,
    required NetworkInfo networkInfo,
    this.requestTimeout = const Duration(seconds: 3),
  }) : _repository = repository,
       _networkInfo = networkInfo;

  final OrganisationGoalsRepository _repository;
  final NetworkInfo _networkInfo;
  final Duration requestTimeout;

  /// Returns goals when they can be fetched quickly while online.
  /// Returns null when offline or the request fails/times out so callers
  /// can show fallback collection lines immediately.
  Future<OrganisationGoalsResponse?> load(String collectGroupId) async {
    if (!_networkInfo.isConnected) {
      return null;
    }

    try {
      return await _repository
          .fetchGoals(collectGroupId)
          .timeout(
            requestTimeout,
          );
    } on Object {
      return null;
    }
  }
}
