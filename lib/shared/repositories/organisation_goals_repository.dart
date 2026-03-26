import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';

mixin OrganisationGoalsRepository {
  Future<OrganisationGoalsSummary> fetchGoalsSummary(String collectGroupId);
  Future<OrganisationGoalsResponse> fetchGoals(String collectGroupId);

  void clearCache();
}

class OrganisationGoalsRepositoryImpl with OrganisationGoalsRepository {
  OrganisationGoalsRepositoryImpl(this._apiService);

  final APIService _apiService;
  final Map<String, OrganisationGoalsSummary> _cache = {};
  final Map<String, OrganisationGoalsResponse> _goalsCache = {};

  @override
  Future<OrganisationGoalsSummary> fetchGoalsSummary(
    String collectGroupId,
  ) async {
    if (_cache.containsKey(collectGroupId)) {
      return _cache[collectGroupId]!;
    }

    final response = await _apiService.fetchOrganisationGoals(collectGroupId);
    final list = _extractList(response);
    final first = list.isEmpty
        ? const OrganisationGoalsResponse()
        : _filterQrCodesWithoutName(
            OrganisationGoalsResponse.fromJson(list.first),
          );
    final summary = first.toSummary();
    _cache[collectGroupId] = summary;
    return summary;
  }

  @override
  Future<OrganisationGoalsResponse> fetchGoals(String collectGroupId) async {
    if (_goalsCache.containsKey(collectGroupId)) {
      return _goalsCache[collectGroupId]!;
    }

    final response = await _apiService.fetchOrganisationGoals(collectGroupId);
    final list = _extractList(response);
    final first = list.isEmpty
        ? const OrganisationGoalsResponse()
        : _filterQrCodesWithoutName(
            OrganisationGoalsResponse.fromJson(list.first),
          );

    _goalsCache[collectGroupId] = first;
    _cache[collectGroupId] = first.toSummary();
    return first;
  }

  List<Map<String, dynamic>> _extractList(Map<String, dynamic> response) {
    final items = response['items'];
    if (items is List<dynamic>) {
      return items.whereType<Map<String, dynamic>>().toList();
    }

    final item = response['item'];
    if (item is List<dynamic>) {
      return item.whereType<Map<String, dynamic>>().toList();
    }
    if (item is Map<String, dynamic>) {
      return [item];
    }

    final result = response['result'];
    if (result is List<dynamic>) {
      return result.whereType<Map<String, dynamic>>().toList();
    }
    if (result is Map<String, dynamic>) {
      return [result];
    }

    return const [];
  }

  /// Drops general goals (QR codes) with no display name so UI and counts stay
  /// consistent.
  OrganisationGoalsResponse _filterQrCodesWithoutName(
    OrganisationGoalsResponse response,
  ) {
    final namedQrCodes = response.qrCodes
        .where((q) => q.allocationName.trim().isNotEmpty)
        .toList();
    return OrganisationGoalsResponse(
      allocations: response.allocations,
      qrCodes: namedQrCodes,
    );
  }

  @override
  void clearCache() {
    _cache.clear();
    _goalsCache.clear();
  }
}
