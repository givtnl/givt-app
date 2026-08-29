import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_transaction.dart';
import 'package:givt_app/features/give/cubit/offline_queue_cubit.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/models/givt.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

class _FakeNetworkInfo with NetworkInfo {
  _FakeNetworkInfo({this.isConnected = true});

  @override
  bool isConnected;

  final _controller = StreamController<bool>.broadcast(sync: true);

  @override
  Stream<bool> hasInternetConnectionStream() => _controller.stream;

  void emitConnection(bool connected) {
    isConnected = connected;
    _controller.add(connected);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

class _FakeGivtRepository with GivtRepository {
  _FakeGivtRepository({List<GivtTransaction> transactions = const []})
    : _transactions = List<GivtTransaction>.from(transactions);

  final _queueController = StreamController<void>.broadcast(sync: true);
  List<GivtTransaction> _transactions;
  int syncCallCount = 0;
  bool failSync = false;

  @override
  Stream<void> get offlineQueueChanged => _queueController.stream;

  @override
  List<GivtTransaction> getCachedOfflineGivtTransactions() => _transactions;

  @override
  Future<void> syncOfflineGivts() async {
    syncCallCount++;
    if (failSync) {
      throw Exception('sync failed');
    }
  }

  void setTransactions(List<GivtTransaction> transactions) {
    _transactions = List<GivtTransaction>.from(transactions);
    _queueController.add(null);
  }

  Future<void> dispose() async {
    await _queueController.close();
  }

  @override
  Future<List<int>> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  }) => throw UnimplementedError();

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

  @override
  Future<int> fetchTransactionStatus(int transactionId) =>
      throw UnimplementedError();
}

const _sampleTransaction = GivtTransaction(
  guid: 'user-1',
  amount: 20,
  beaconId: 'beacon-1',
  timestamp: '2026-01-01T00:00:00Z',
  collectId: '1',
);

void main() {
  group('OfflineQueueCubit', () {
    late _FakeGivtRepository repository;
    late _FakeNetworkInfo networkInfo;
    late OfflineQueueCubit cubit;

    tearDown(() async {
      await cubit.close();
      await repository.dispose();
      await networkInfo.dispose();
    });

    test('shows offline banner on cold start without a stream event', () {
      networkInfo = _FakeNetworkInfo(isConnected: false);
      repository = _FakeGivtRepository();
      cubit = OfflineQueueCubit(repository, networkInfo);

      expect(cubit.state.hasResolvedConnectivity, isTrue);
      expect(cubit.state.isOffline, isTrue);
      expect(cubit.state.shouldShowBanner, isTrue);
    });

    test('marks connectivity resolved and shows offline banner', () async {
      networkInfo = _FakeNetworkInfo(isConnected: true);
      repository = _FakeGivtRepository();
      cubit = OfflineQueueCubit(repository, networkInfo);

      networkInfo.emitConnection(false);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.hasResolvedConnectivity, isTrue);
      expect(cubit.state.isOffline, isTrue);
      expect(cubit.state.shouldShowBanner, isTrue);
    });

    test('syncs when reconnecting after being offline', () async {
      networkInfo = _FakeNetworkInfo(isConnected: false);
      repository = _FakeGivtRepository(
        transactions: const [_sampleTransaction],
      );
      cubit = OfflineQueueCubit(repository, networkInfo);

      networkInfo.emitConnection(false);
      await Future<void>.delayed(Duration.zero);

      final syncCountBeforeReconnect = repository.syncCallCount;

      networkInfo.emitConnection(true);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(repository.syncCallCount, greaterThan(syncCountBeforeReconnect));
      expect(cubit.state.isOffline, isFalse);
    });

    test('keeps pending count when sync fails while online', () async {
      networkInfo = _FakeNetworkInfo(isConnected: true);
      repository = _FakeGivtRepository(
        transactions: const [_sampleTransaction],
      );
      repository.failSync = true;
      cubit = OfflineQueueCubit(repository, networkInfo);

      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.pendingCount, 1);
      expect(cubit.state.isOffline, isFalse);
      expect(cubit.state.shouldShowBanner, isTrue);
    });
  });
}
