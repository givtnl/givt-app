import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/give/utils/offline_aware_organisation_goals_loader.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';

class _FakeNetworkInfo with NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
}

class _FakeOrganisationGoalsRepository with OrganisationGoalsRepository {
  _FakeOrganisationGoalsRepository({required this.onFetch});

  final Future<OrganisationGoalsResponse> Function() onFetch;
  int fetchCount = 0;

  @override
  Future<OrganisationGoalsSummary> fetchGoalsSummary(
    String collectGroupId,
  ) async => const OrganisationGoalsSummary.empty();

  @override
  Future<OrganisationGoalsResponse> fetchGoals(String collectGroupId) async {
    fetchCount++;
    return onFetch();
  }

  @override
  void clearCache() {}
}

void main() {
  group('OfflineAwareOrganisationGoalsLoader', () {
    test('skips the request when already offline', () async {
      final repository = _FakeOrganisationGoalsRepository(
        onFetch: () async => const OrganisationGoalsResponse(),
      );
      final loader = OfflineAwareOrganisationGoalsLoader(
        repository: repository,
        networkInfo: _FakeNetworkInfo(isConnected: false),
      );

      final result = await loader.load('org-1');

      expect(result, isNull);
      expect(repository.fetchCount, 0);
    });

    test('returns goals when the request succeeds while online', () async {
      const response = OrganisationGoalsResponse();
      final repository = _FakeOrganisationGoalsRepository(
        onFetch: () async => response,
      );
      final loader = OfflineAwareOrganisationGoalsLoader(
        repository: repository,
        networkInfo: _FakeNetworkInfo(isConnected: true),
      );

      final result = await loader.load('org-1');

      expect(result, same(response));
      expect(repository.fetchCount, 1);
    });

    test('returns null when the request exceeds the timeout', () async {
      final repository = _FakeOrganisationGoalsRepository(
        onFetch: () => Completer<OrganisationGoalsResponse>().future,
      );
      final loader = OfflineAwareOrganisationGoalsLoader(
        repository: repository,
        networkInfo: _FakeNetworkInfo(isConnected: true),
        requestTimeout: const Duration(milliseconds: 20),
      );

      final result = await loader.load('org-1');

      expect(result, isNull);
      expect(repository.fetchCount, 1);
    });
  });
}
