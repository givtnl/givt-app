import 'package:flutter_test/flutter_test.dart';
import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/recurring_donations/detail/repositories/recurring_donation_detail_repository.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeNetworkInfo with NetworkInfo {
  @override
  bool get isConnected => true;

  @override
  Stream<bool> hasInternetConnectionStream() => const Stream.empty();
}

class _FakeApiService extends APIService {
  _FakeApiService(RequestHelper requestHelper) : super(requestHelper);

  Map<String, dynamic> response = const {
    'item': {
      'transactions': <Map<String, dynamic>>[],
    },
  };

  @override
  Future<Map<String, dynamic>> fetchRecurringDonationById(
    String donationId,
  ) async {
    return response;
  }
}

class _FakeCollectGroupRepository with CollectGroupRepository {
  @override
  Future<List<CollectGroup>> fetchCollectGroupList() async {
    return const [];
  }

  @override
  Future<List<CollectGroup>> getCollectGroupList() async {
    return const [];
  }
}

void main() {
  group('RecurringDonationDetailRepositoryImpl', () {
    late RecurringDonationDetailRepositoryImpl repository;
    late _FakeApiService apiService;
    late _FakeCollectGroupRepository collectGroupRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final networkInfo = _FakeNetworkInfo();
      final requestHelper = RequestHelper(
        networkInfo,
        prefs,
        apiURL: 'api.example.com',
      );

      apiService = _FakeApiService(requestHelper);
      collectGroupRepository = _FakeCollectGroupRepository();
      repository = RecurringDonationDetailRepositoryImpl(
        apiService,
        collectGroupRepository,
      );
    });

    RecurringDonation _buildDonation({
      required RecurringDonationState state,
      String? endDate,
      int numberOfTurns = 999,
      String? startDate,
    }) {
      final start =
          startDate ??
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
      return RecurringDonation(
        id: 'donation-id',
        userId: 'user-id',
        amount: 10,
        frequency: Frequency.monthly,
        numberOfTurns: numberOfTurns,
        startDate: start,
        endDate: endDate,
        currentState: state,
        creationDateTime: start,
        collectGroupName: 'Test Org',
        transactions: const [],
        nextRecurringDonation: null,
        currentTurn: 0,
      );
    }

    test(
      'isRecurringDonationActive returns true and prepends upcoming donation for active donations with future end date',
      () async {
        final futureEndDate = DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String();
        final donation = _buildDonation(
          state: RecurringDonationState.active,
          endDate: futureEndDate,
          numberOfTurns: 12,
        );

        repository.setRecurringDonation(donation);

        await repository.loadRecurringDonationDetail();

        expect(repository.isRecurringDonationActive(), isTrue);

        final history = repository.getHistory();
        expect(history, hasLength(1));
      },
    );

    test(
      'isRecurringDonationActive returns false and does not prepend upcoming donation for cancelled donations',
      () async {
        final futureEndDate = DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String();
        final donation = _buildDonation(
          state: RecurringDonationState.cancelled,
          endDate: futureEndDate,
          numberOfTurns: 12,
        );

        repository.setRecurringDonation(donation);

        await repository.loadRecurringDonationDetail();

        expect(repository.isRecurringDonationActive(), isFalse);

        final history = repository.getHistory();
        expect(history, isEmpty);
      },
    );

    test(
      'isRecurringDonationActive returns false and does not prepend upcoming donation for finished donations',
      () async {
        final pastEndDate = DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String();
        final donation = _buildDonation(
          state: RecurringDonationState.finished,
          endDate: pastEndDate,
          numberOfTurns: 12,
        );

        repository.setRecurringDonation(donation);

        await repository.loadRecurringDonationDetail();

        expect(repository.isRecurringDonationActive(), isFalse);

        final history = repository.getHistory();
        expect(history, isEmpty);
      },
    );

    test(
      'isRecurringDonationActive returns false and does not prepend upcoming donation for stopped donations',
      () async {
        final futureEndDate = DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String();
        final donation = _buildDonation(
          state: RecurringDonationState.stopped,
          endDate: futureEndDate,
          numberOfTurns: 12,
        );

        repository.setRecurringDonation(donation);

        await repository.loadRecurringDonationDetail();

        expect(repository.isRecurringDonationActive(), isFalse);

        final history = repository.getHistory();
        expect(history, isEmpty);
      },
    );

    test(
      'isRecurringDonationActive returns false and does not prepend upcoming donation when active but end date is in the past',
      () async {
        final pastEndDate = DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String();
        final donation = _buildDonation(
          state: RecurringDonationState.active,
          endDate: pastEndDate,
          numberOfTurns: 12,
        );

        repository.setRecurringDonation(donation);

        await repository.loadRecurringDonationDetail();

        expect(repository.isRecurringDonationActive(), isFalse);

        final history = repository.getHistory();
        expect(history, isEmpty);
      },
    );
  });
}
