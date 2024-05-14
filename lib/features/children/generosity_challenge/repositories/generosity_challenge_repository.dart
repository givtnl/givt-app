import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:givt_app/features/children/generosity_challenge/models/day.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin GenerosityChallengeRepository {
  Future<void> saveToCache(List<Day> days);

  Future<List<Day>> loadFromCache();

  Future<void> clearCache();

  Future<void> saveUserData(ChatScriptSaveKey key, String value);

  Map<String, dynamic> loadUserData();
}

class GenerosityChallengeRepositoryImpl with GenerosityChallengeRepository {
  GenerosityChallengeRepositoryImpl(
    this.sharedPreferences,
  );

  static const String _generosityChallengeDaysKey = 'generosityChallengeDays';
  static const String _generosityChallengeUserDataKey =
      'generosityChallengeUserDataKey';

  final SharedPreferences sharedPreferences;

  @override
  Future<void> saveToCache(List<Day> days) async {
    final daysJsonList = days.map((day) => day.toMap()).toList();

    await sharedPreferences.setString(
      _generosityChallengeDaysKey,
      jsonEncode(daysJsonList),
    );
  }

  @override
  Future<List<Day>> loadFromCache() async {
    try {
      final encodedString =
          sharedPreferences.getString(_generosityChallengeDaysKey) ?? '';
      if (encodedString.isNotEmpty) {
        final result = (jsonDecode(encodedString) as List<dynamic>)
            .map<Day>(
              (day) => Day.fromMap(day as Map<String, dynamic>),
            )
            .toList();
        return result;
      } else {
        return await _saveAndReturnEmptyDays();
      }
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      return _saveAndReturnEmptyDays();
    }
  }

  Future<List<Day>> _saveAndReturnEmptyDays() async {
    final days = List<Day>.filled(
      GenerosityChallengeHelper.generosityChallengeDays,
      const Day.empty(),
    );
    await saveToCache(days);
    return days;
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_generosityChallengeDaysKey);
  }

  @override
  Map<String, dynamic> loadUserData() {
    final encodedString =
        sharedPreferences.getString(_generosityChallengeUserDataKey) ?? '';

    return encodedString.isNotEmpty
        ? jsonDecode(encodedString) as Map<String, dynamic>
        : <String, dynamic>{};
  }

  @override
  Future<void> saveUserData(ChatScriptSaveKey key, String value) async {
    if (!key.isSupported) {
      return;
    }

    final currentData = loadUserData();
    currentData[key.value] = value;

    await sharedPreferences.setString(
      _generosityChallengeUserDataKey,
      jsonEncode(currentData),
    );
  }
}
