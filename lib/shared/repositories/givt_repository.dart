import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:givt_app/features/overview/models/givt.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin GivtRepository {
  Future<void> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  });
  Future<void> syncOfflineGivts();

  Future<List<Givt>> fetchGivts();
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
    final givts = jsonDecode(givtsString) as Map<String, dynamic>;
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
}
