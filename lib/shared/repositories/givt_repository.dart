// ignore_for_file: equal_keys_in_map

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/failures/failures.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_transaction.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/models/givt.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin GivtRepository {
  Stream<void> get offlineQueueChanged;

  List<GivtTransaction> getCachedOfflineGivtTransactions();

  Future<List<int>> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  });

  Future<void> syncOfflineGivts();

  Future<List<Givt>> fetchGivts();

  Future<List<Pledge>> fetchPledges();

  Future<PledgeGroup> fetchPledgeGroupDetail(String pledgeGroupId);

  Future<List<ExternalDonation>> fetchExternalDonations();

  Future<List<ExternalDonation>> fetchExternalDonationSummary({
    required String fromDate,
    required String tillDate,
  });

  Future<List<ExternalDonationTransaction>> fetchExternalDonationTransactions(
    String externalDonationId,
  );

  Future<bool> stopExternalDonation(String id);

  Future<bool> deleteGivt(List<dynamic> ids);

  Future<bool> downloadYearlyOverview({
    required String fromDate,
    required String toDate,
  });

  Future<ExternalDonation?> addExternalDonation({
    required Map<String, dynamic> body,
  });

  Future<ExternalDonation?> fetchExternalDonationDetail(String id);

  Future<bool> updateExternalDonation({
    required String id,
    required Map<String, dynamic> body,
  });

  Future<bool> deleteExternalDonation(String id);

  Future<bool> bulkUpdateExternalDonationTransactions({
    required List<String> transactionIds,
    required double newAmount,
  });

  Future<bool> bulkDeleteExternalDonationTransactions({
    required List<String> transactionIds,
  });

  Future<List<SummaryItem>> fetchSummary({
    required String guid,
    required String fromDate,
    required String tillDate,
    required String orderType,
    required String groupType,
  });
}

class GivtRepositoryImpl with GivtRepository {
  GivtRepositoryImpl(this.apiClient, this.prefs);

  final APIService apiClient;
  final SharedPreferences prefs;

  final StreamController<void> _offlineQueueChangedController =
      StreamController<void>.broadcast();

  Future<void>? _syncOfflineGivtsInFlight;

  @override
  Stream<void> get offlineQueueChanged =>
      _offlineQueueChangedController.stream;

  @override
  List<GivtTransaction> getCachedOfflineGivtTransactions() {
    final givtsString = prefs.getString(GivtTransaction.givtTransactions);
    if (givtsString == null || givtsString.isEmpty) {
      return [];
    }

    try {
      final givts = jsonDecode(givtsString) as Map<String, dynamic>;
      final donations = givts['donations'] as List<dynamic>?;
      if (donations == null || donations.isEmpty) {
        return [];
      }
      return GivtTransaction.fromJsonList(donations);
    } catch (e, stackTrace) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: stackTrace.toString(),
      );
      return [];
    }
  }

  void _notifyOfflineQueueChanged() {
    if (!_offlineQueueChangedController.isClosed) {
      _offlineQueueChangedController.add(null);
    }
  }

  @override
  Future<List<int>> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  }) async {
    final givts = <String, dynamic>{
      'donationType': 0,
    }..addAll(body);

    try {
      await syncOfflineGivts();
      final result = await apiClient.submitGivts(
        body: givts,
        guid: guid,
      );

      return result;
    } on SocketException {
      await _cacheGivts(body);

      throw const SocketException('No internet connection');
    }
  }

  Future<void> _cacheGivts(
    Map<String, dynamic> body,
  ) async {
    if (!prefs.containsKey(GivtTransaction.givtTransactions)) {
      await prefs.setString(
        GivtTransaction.givtTransactions,
        jsonEncode(
          <String, dynamic>{
            'donationType': 0,
          }..addAll(body),
        ),
      );
    } else {
      final givtsString = prefs.getString(
        GivtTransaction.givtTransactions,
      );
      final givts = jsonDecode(givtsString!) as Map<String, dynamic>;
      final donations = (givts['donations'] as List<dynamic>)
        ..addAll(
          body['donations'] as List<dynamic>,
        );
      givts['donations'] = donations;

      await prefs.setString(
        GivtTransaction.givtTransactions,
        jsonEncode(givts),
      );
    }
    _notifyOfflineQueueChanged();
  }

  @override
  Future<void> syncOfflineGivts() {
    final inFlight = _syncOfflineGivtsInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final sync = _syncOfflineGivtsOnce();
    _syncOfflineGivtsInFlight = sync;
    return sync.whenComplete(() {
      if (identical(_syncOfflineGivtsInFlight, sync)) {
        _syncOfflineGivtsInFlight = null;
      }
    });
  }

  Future<void> _syncOfflineGivtsOnce() async {
    try {
      final givtsString = prefs.getString(
        GivtTransaction.givtTransactions,
      );
      if (givtsString == null) {
        return;
      }
      if (givtsString.isEmpty) {
        return;
      }

      final givts = jsonDecode(givtsString) as Map<String, dynamic>;
      if (givts.isEmpty) {
        return;
      }
      if ((givts['donations'] as List<dynamic>).isEmpty) {
        return;
      }
      final firstTransaction = GivtTransaction.fromJsonList(
        givts['donations'] as List<dynamic>,
      ).first;
      await apiClient.submitGivts(
        body: givts,
        guid: firstTransaction.guid,
      );
      await prefs.remove(
        GivtTransaction.givtTransactions,
      );
      _notifyOfflineQueueChanged();
    } on GivtServerFailure catch (e, stackTrace) {
      final statusCode = e.statusCode;
      final body = e.body;
      LoggingInfo.instance.error(
        body.toString(),
        methodName: stackTrace.toString(),
      );
      if (statusCode == 417) {
        await prefs.remove(
          GivtTransaction.givtTransactions,
        );
        _notifyOfflineQueueChanged();
      }
      rethrow;
    }
  }

  @override
  Future<List<Givt>> fetchGivts() async {
    final decodedJson = await apiClient.fetchGivts();
    return Givt.fromJsonList(
      decodedJson,
    );
  }

  @override
  Future<bool> deleteGivt(List<dynamic> ids) async {
    final result = apiClient.deleteGivts(body: ids);
    return result;
  }

  @override
  Future<bool> downloadYearlyOverview({
    required String fromDate,
    required String toDate,
  }) async {
    return apiClient.downloadYearlyOverview(fromDate, toDate);
  }

  @override
  Future<List<SummaryItem>> fetchSummary({
    required String guid,
    required String fromDate,
    required String tillDate,
    required String orderType,
    required String groupType,
  }) async {
    final params = {
      'OrderType': orderType,
      'GroupType': groupType,
      'FromDate': fromDate,
      'TillDate': tillDate,
      'TransactionStatusses': '1',
      'TransactionStatusses': '2',
      'TransactionStatusses': '3',
    };
    try {
      final decodedJson = await apiClient.fetchMonthlySummary(guid, params);
      return SummaryItem.fromJsonList(
        decodedJson,
      );
    } catch (e) {
      LoggingInfo.instance.error(
        e.toString(),
        methodName: 'fetchSummary',
      );
      return [];
    }
  }

  @override
  Future<List<Pledge>> fetchPledges() async {
    final decodedJson = await apiClient.fetchPledges();
    return Pledge.fromApiItems(decodedJson);
  }

  @override
  Future<PledgeGroup> fetchPledgeGroupDetail(String pledgeGroupId) async {
    final item = await apiClient.fetchPledgeGroupDetail(pledgeGroupId);
    return PledgeGroup.fromJson(item);
  }

  @override
  Future<List<ExternalDonation>> fetchExternalDonations() async {
    final decodedJson = await apiClient.fetchExternalDonations();
    return ExternalDonation.fromJsonList(
      decodedJson,
    );
  }

  @override
  Future<List<ExternalDonation>> fetchExternalDonationSummary({
    required String fromDate,
    required String tillDate,
  }) async {
    final params = {
      'startDate': fromDate,
      'endDate': tillDate,
    };
    final decodedJson = await apiClient.fetchExternalDonationsSearch(
      params: params,
    );
    return ExternalDonation.fromJsonList(
      decodedJson,
    );
  }

  @override
  Future<List<ExternalDonationTransaction>> fetchExternalDonationTransactions(
    String externalDonationId,
  ) async {
    final decodedJson = await apiClient.fetchExternalDonationTransactions(
      externalDonationId,
    );
    return ExternalDonationTransaction.fromJsonList(decodedJson);
  }

  @override
  Future<bool> stopExternalDonation(String id) async {
    return apiClient.stopExternalDonation(id);
  }

  @override
  Future<ExternalDonation?> addExternalDonation({
    required Map<String, dynamic> body,
  }) async {
    return apiClient.addExternalDonation(body);
  }

  @override
  Future<ExternalDonation?> fetchExternalDonationDetail(String id) async {
    return apiClient.fetchExternalDonationDetail(id);
  }

  @override
  Future<bool> updateExternalDonation({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final result = apiClient.updateExternalDonation(id, body);
    return result;
  }

  @override
  Future<bool> deleteExternalDonation(String id) async {
    return apiClient.deleteExternalDonation(id);
  }

  @override
  Future<bool> bulkUpdateExternalDonationTransactions({
    required List<String> transactionIds,
    required double newAmount,
  }) async {
    return apiClient.bulkUpdateExternalDonationTransactions(
      transactionIds: transactionIds,
      newAmount: newAmount,
    );
  }

  @override
  Future<bool> bulkDeleteExternalDonationTransactions({
    required List<String> transactionIds,
  }) async {
    return apiClient.bulkDeleteExternalDonationTransactions(
      transactionIds: transactionIds,
    );
  }
}
