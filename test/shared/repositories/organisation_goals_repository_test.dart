import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeNetworkInfo with NetworkInfo {
  @override
  bool isConnected = true;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
}

class _FakeApiService extends APIService {
  _FakeApiService(RequestHelper requestHelper) : super(requestHelper);

  final calls = <String>[];
  final responses = <String, Map<String, dynamic>>{};

  @override
  Future<Map<String, dynamic>> fetchOrganisationGoals(
    String collectGroupId,
  ) async {
    calls.add(collectGroupId);
    return responses[collectGroupId]!;
  }
}

Map<String, dynamic> _goalsBody(String collectGroupId, int allocationsCount) {
  return {
    'items': [
      {
        'allocations': [
          for (var index = 0; index < allocationsCount; index++)
            {
              'collectId': '$index',
              'allocationName': 'Goal $index',
              'collectGroupId': collectGroupId,
            },
        ],
        'qrCodes': <Map<String, dynamic>>[],
      },
    ],
  };
}

void main() {
  test(
    'forceRefresh refetches one summary and drops only that goals cache',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final api = _FakeApiService(
        RequestHelper(
          _FakeNetworkInfo(),
          preferences,
          apiURL: 'api.example.com',
        ),
      );
      api.responses['org-a'] = _goalsBody('org-a', 1);
      api.responses['org-b'] = _goalsBody('org-b', 1);
      final repository = OrganisationGoalsRepositoryImpl(api);

      final first = await repository.fetchGoalsSummary('org-a');
      final cached = await repository.fetchGoalsSummary('org-a');

      expect(first.allocationsCount, 1);
      expect(cached.allocationsCount, 1);
      expect(api.calls, ['org-a']);

      await repository.fetchGoals('org-b');
      await repository.fetchGoals('org-a');
      expect(api.calls, ['org-a', 'org-b', 'org-a']);

      api.responses['org-a'] = _goalsBody('org-a', 2);
      final refreshed = await repository.fetchGoalsSummary(
        'org-a',
        forceRefresh: true,
      );

      expect(refreshed.allocationsCount, 2);
      expect(api.calls, ['org-a', 'org-b', 'org-a', 'org-a']);

      final refreshedGoals = await repository.fetchGoals('org-a');
      expect(refreshedGoals.allocations.length, 2);
      expect(api.calls, ['org-a', 'org-b', 'org-a', 'org-a', 'org-a']);

      final callsBeforeOtherId = List<String>.of(api.calls);
      final cachedOtherGoals = await repository.fetchGoals('org-b');
      expect(api.calls, callsBeforeOtherId);
      expect(cachedOtherGoals.allocations.length, 1);
    },
  );
}
