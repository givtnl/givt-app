// ignore_for_file: equal_keys_in_map

import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/features/overview/models/givt.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin GivtRepository {
  Future<void> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  });
  Future<void> syncOfflineGivts();

  Future<List<Givt>> fetchGivts();

  Future<List<ExternalDonation>> fetchExternalDonations({
    required String fromDate,
    required String tillDate,
  });

  Future<bool> deleteExternalDonation(String id);

  Future<bool> deleteGivt(List<dynamic> ids);

  Future<bool> downloadYearlyOverview({required Map<String, dynamic> body});

  Future<bool> addExternalDonation({
    required Map<String, dynamic> body,
  });

  Future<bool> updateExternalDonation({
    required String id,
    required Map<String, dynamic> body,
  });

  Future<List<SummaryItem>> fetchSummary({
    required String guid,
    required String fromDate,
    required String tillDate,
    required String orderType ,
    required String groupType,
  });
}

class GivtRepositoryImpl with GivtRepository {
  GivtRepositoryImpl(this.apiClient, this.prefs);

  final APIService apiClient;
  final SharedPreferences prefs;

  @override
  Future<void> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  }) async {
    final givts = <String, dynamic>{
      'donationType': 0,
    }..addAll(body);
    try {
      await syncOfflineGivts();
      await apiClient.submitGivts(
        body: givts,
        guid: guid,
      );
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
  }

  @override
  Future<void> syncOfflineGivts() async {
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
  }

  @override
  Future<List<Givt>> fetchGivts() async {
    final decodedJson = await apiClient.fetchGivts();
    return Givt.fromJsonList(
      decodedJson,
    );
  }

  @override
  Future<bool> deleteGivt(List<dynamic> ids) async =>
      apiClient.deleteGivts(body: ids);

  @override
  Future<bool> downloadYearlyOverview(
      {required Map<String, dynamic> body}) async {
    return apiClient.downloadYearlyOverview(body);
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
      // 'TransactionStatusses': '1',
      // 'TransactionStatusses': '2',
      // 'TransactionStatusses': '3',
    };
    final decodedJson = await apiClient.fetchMonthlySummary(guid, params);
    return SummaryItem.fromJsonList(
      decodedJson,
    );
  }

  @override
  Future<List<ExternalDonation>> fetchExternalDonations({
    required String fromDate,
    required String tillDate,
  }) async {
    final params = {
      'fromDate': fromDate,
      'tillDate': tillDate,
    };
    final decodedJson = await apiClient.fetchExternalDonations(params: params);
    return ExternalDonation.fromJsonList(
      decodedJson,
    );
  }

  @override
  Future<bool> deleteExternalDonation(String id) async {
    return apiClient.deleteExternalDonation(id);
  }

  @override
  Future<bool> addExternalDonation({
    required Map<String, dynamic> body,
  }) async {
    return apiClient.addExternalDonation(body);
  }

  @override
  Future<bool> updateExternalDonation({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    return apiClient.updateExternalDonation(id, body);
  }
}
