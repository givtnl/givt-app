import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_transaction.dart';
import 'package:givt_app/features/give/cubit/give_result_cubit.dart';
import 'package:givt_app/features/give/cubit/give_result_uimodel.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/models/givt.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeGivtRepository with GivtRepository {
  _FakeGivtRepository({this.statusResult, this.failCount = 0});

  int? statusResult;
  int failCount;
  int fetchCount = 0;

  @override
  Future<int> fetchTransactionStatus(int transactionId) async {
    fetchCount++;
    if (failCount > 0) {
      failCount--;
      throw Exception('status unavailable');
    }
    final status = statusResult;
    if (status == null) {
      throw Exception('status unavailable');
    }
    return status;
  }

  @override
  Stream<void> get offlineQueueChanged => const Stream.empty();

  @override
  List<GivtTransaction> getCachedOfflineGivtTransactions() => const [];

  @override
  Future<List<int>> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  }) => throw UnimplementedError();

  @override
  Future<void> syncOfflineGivts() => throw UnimplementedError();

  @override
  Future<List<Givt>> fetchGivts() => throw UnimplementedError();

  @override
  Future<List<Pledge>> fetchPledges() => throw UnimplementedError();

  @override
  Future<PledgeGroup> fetchPledgeGroupDetail(String pledgeGroupId) =>
      throw UnimplementedError();

  @override
  Future<List<ExternalDonation>> fetchExternalDonations() =>
      throw UnimplementedError();

  @override
  Future<List<ExternalDonation>> fetchExternalDonationSummary({
    required String fromDate,
    required String tillDate,
  }) => throw UnimplementedError();

  @override
  Future<List<ExternalDonationTransaction>> fetchExternalDonationTransactions(
    String externalDonationId,
  ) => throw UnimplementedError();

  @override
  Future<bool> stopExternalDonation(String id) => throw UnimplementedError();

  @override
  Future<bool> deleteGivt(List<dynamic> ids) => throw UnimplementedError();

  @override
  Future<bool> downloadYearlyOverview({
    required String fromDate,
    required String toDate,
  }) => throw UnimplementedError();

  @override
  Future<ExternalDonation?> addExternalDonation({
    required Map<String, dynamic> body,
  }) => throw UnimplementedError();

  @override
  Future<ExternalDonation?> fetchExternalDonationDetail(String id) =>
      throw UnimplementedError();

  @override
  Future<bool> updateExternalDonation({
    required String id,
    required Map<String, dynamic> body,
  }) => throw UnimplementedError();

  @override
  Future<bool> deleteExternalDonation(String id) => throw UnimplementedError();

  @override
  Future<bool> bulkUpdateExternalDonationTransactions({
    required List<String> transactionIds,
    required double newAmount,
  }) => throw UnimplementedError();

  @override
  Future<bool> bulkDeleteExternalDonationTransactions({
    required List<String> transactionIds,
  }) => throw UnimplementedError();

  @override
  Future<List<SummaryItem>> fetchSummary({
    required String guid,
    required String fromDate,
    required String tillDate,
    required String orderType,
    required String groupType,
  }) => throw UnimplementedError();
}

void main() {
  group('GiveResultUIModel.fromLegacyStatus', () {
    test('maps entered, to-process and processed as success', () {
      expect(GiveResultUIModel.fromLegacyStatus(1), GiveResultOutcome.success);
      expect(GiveResultUIModel.fromLegacyStatus(2), GiveResultOutcome.success);
      expect(GiveResultUIModel.fromLegacyStatus(3), GiveResultOutcome.success);
    });

    test('maps rejected and cancelled as failed', () {
      expect(GiveResultUIModel.fromLegacyStatus(4), GiveResultOutcome.failed);
      expect(GiveResultUIModel.fromLegacyStatus(5), GiveResultOutcome.failed);
    });

    test('maps unknown values as unknown', () {
      expect(GiveResultUIModel.fromLegacyStatus(0), GiveResultOutcome.unknown);
      expect(GiveResultUIModel.fromLegacyStatus(-1), GiveResultOutcome.unknown);
    });
  });

  group('GiveResultCubit', () {
    Future<void> noSleep(Duration duration) async {}

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('emits unknown when there are no transaction ids', () async {
      final cubit = GiveResultCubit(
        _FakeGivtRepository(statusResult: 1),
        sleeper: noSleep,
      );

      await cubit.checkStatus(const []);

      final state = cubit.state;
      expect(state, isA<DataState<GiveResultUIModel, dynamic>>());
      expect(
        (state as DataState<GiveResultUIModel, dynamic>).data.outcome,
        GiveResultOutcome.unknown,
      );
      await cubit.close();
    });

    test('emits success for processed status', () async {
      final cubit = GiveResultCubit(
        _FakeGivtRepository(statusResult: 3),
        sleeper: noSleep,
      );

      await cubit.checkStatus(const [42]);

      final state = cubit.state as DataState<GiveResultUIModel, dynamic>;
      expect(state.data.outcome, GiveResultOutcome.success);
      await cubit.close();
    });

    test('emits failed for cancelled status', () async {
      final cubit = GiveResultCubit(
        _FakeGivtRepository(statusResult: 5),
        sleeper: noSleep,
      );

      await cubit.checkStatus(const [42]);

      final state = cubit.state as DataState<GiveResultUIModel, dynamic>;
      expect(state.data.outcome, GiveResultOutcome.failed);
      await cubit.close();
    });

    test('retries after a failed fetch then emits success', () async {
      final repository = _FakeGivtRepository(statusResult: 1, failCount: 1);
      final cubit = GiveResultCubit(
        repository,
        timeout: const Duration(seconds: 10),
        sleeper: noSleep,
      );

      await cubit.checkStatus(const [42]);

      expect(repository.fetchCount, 2);
      final state = cubit.state as DataState<GiveResultUIModel, dynamic>;
      expect(state.data.outcome, GiveResultOutcome.success);
      await cubit.close();
    });

    test('emits unknown when fetches keep failing past the timeout', () async {
      final repository = _FakeGivtRepository();
      final cubit = GiveResultCubit(
        repository,
        timeout: Duration.zero,
        sleeper: noSleep,
      );

      await cubit.checkStatus(const [42]);

      expect(repository.fetchCount, 1);
      final state = cubit.state as DataState<GiveResultUIModel, dynamic>;
      expect(state.data.outcome, GiveResultOutcome.unknown);
      await cubit.close();
    });
  });
}
