import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/give/cubit/for_you_goals_cubit.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';

class _FakeNetworkInfo with NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> hasInternetConnectionStream() => _controller.stream;

  Future<void> dispose() => _controller.close();
}

class _FakeGoalsRepository with OrganisationGoalsRepository {
  final pending = <String, Completer<OrganisationGoalsSummary>>{};

  @override
  Future<OrganisationGoalsSummary> fetchGoalsSummary(String collectGroupId) {
    final completer = Completer<OrganisationGoalsSummary>();
    pending[collectGroupId] = completer;
    return completer.future;
  }

  void complete(String collectGroupId, OrganisationGoalsSummary summary) {
    pending[collectGroupId]!.complete(summary);
  }

  @override
  Future<OrganisationGoalsResponse> fetchGoals(String collectGroupId) async {
    return const OrganisationGoalsResponse();
  }

  @override
  void clearCache() {}
}

void main() {
  const firstSummary = OrganisationGoalsSummary(
    allocationsCount: 1,
    qrCodesCount: 2,
  );
  const secondSummary = OrganisationGoalsSummary(
    allocationsCount: 4,
    qrCodesCount: 5,
  );

  group('ForYouGoalsCubit', () {
    late _FakeNetworkInfo networkInfo;
    late _FakeGoalsRepository repository;

    setUp(() {
      networkInfo = _FakeNetworkInfo(isConnected: true);
      repository = _FakeGoalsRepository();
    });

    tearDown(() async {
      await networkInfo.dispose();
    });

    test('emits loading then the summary', () async {
      final cubit = ForYouGoalsCubit(repository, networkInfo);

      final load = cubit.loadForFavorites(const ['org-a']);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.loadingIds, {'org-a'});
      expect(cubit.state.summariesByCollectGroupId, isEmpty);

      repository.complete('org-a', firstSummary);
      await load;

      expect(cubit.state.loadingIds, isEmpty);
      expect(cubit.state.summariesByCollectGroupId['org-a'], firstSummary);
      await cubit.close();
    });

    test('does not emit after close while a fetch is pending', () async {
      final cubit = ForYouGoalsCubit(repository, networkInfo);

      final load = cubit.loadForFavorites(const ['org-a']);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.loadingIds, {'org-a'});

      await cubit.close();
      repository.complete('org-a', firstSummary);
      await load;

      expect(cubit.state.loadingIds, {'org-a'});
      expect(cubit.state.summariesByCollectGroupId, isEmpty);
    });

    test('keeps the newer load when an older fetch finishes last', () async {
      final cubit = ForYouGoalsCubit(repository, networkInfo);

      final firstLoad = cubit.loadForFavorites(const ['org-a']);
      await Future<void>.delayed(Duration.zero);
      final secondLoad = cubit.loadForFavorites(const ['org-b']);
      await Future<void>.delayed(Duration.zero);

      repository.complete('org-b', secondSummary);
      await secondLoad;

      expect(cubit.state.summariesByCollectGroupId.keys, ['org-b']);
      expect(cubit.state.summariesByCollectGroupId['org-b'], secondSummary);

      repository.complete('org-a', firstSummary);
      await firstLoad;

      expect(cubit.state.summariesByCollectGroupId.keys, ['org-b']);
      expect(
        cubit.state.summariesByCollectGroupId['org-b']?.allocationsCount,
        4,
      );
      expect(cubit.state.summariesByCollectGroupId['org-b']?.qrCodesCount, 5);
      await cubit.close();
    });
  });
}
