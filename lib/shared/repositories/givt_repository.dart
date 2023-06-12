import 'dart:convert';
import 'dart:io';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/give/models/givt_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GivtRepository {
  GivtRepository(this._apiClient, this._prefs);

  final APIService _apiClient;
  final SharedPreferences _prefs;

  Future<void> submitGivts({
    required String guid,
    required Map<String, dynamic> body,
  }) async {
    final givts = <String, dynamic>{
      'donationType': 0,
    }..addAll(body);
    try {
      await _apiClient.submitGivts(
        body: givts,
        guid: guid,
      );
    } on SocketException {
      await _prefs.setString(
        GivtTransaction.givtTransactions,
        jsonEncode(givts),
      );
      throw const SocketException('No internet connection');
    }
  }

  Future<void> syncOfflineGivts() async {
    final givtsString = _prefs.getString(
      GivtTransaction.givtTransactions,
    );
    if (givtsString == null) {
      return;
    }
    final givts = jsonDecode(givtsString) as Map<String, dynamic>;
    final firstTransaction = GivtTransaction.fromJsonList(
      givts['donations'] as List<dynamic>,
    ).first;
    await _apiClient.submitGivts(
      body: givts,
      guid: firstTransaction.guid,
    );
    await _prefs.remove(
      GivtTransaction.givtTransactions,
    );
  }
}
