import 'dart:convert';
import 'dart:developer';
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

  Future<void> clearUserData();

  Future<String> loadFromKey(String key);

  Future<bool> isAlreadyRegistered();

  Future<void> setAlreadyRegistered({required bool isAlreadyRegistered});
}

class GenerosityChallengeRepositoryImpl with GenerosityChallengeRepository {
  GenerosityChallengeRepositoryImpl(
    this.sharedPreferences,
  );

  static const String _generosityChallengeDaysKey = 'generosityChallengeDays';
  static const String _generosityChallengeUserDataKey =
      'generosityChallengeUserDataKey';
  static const String _generosityChallengeIsAlreadyRegisteredKey =
      'generosityChallengeIsAlreadyRegisteredKey';

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
        if (result.length < GenerosityChallengeHelper.generosityChallengeDays) {
          return await _addExtraDays(result);
        }
        return result;
      } else {
        return await _saveAndReturnEmptyDays();
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return _saveAndReturnEmptyDays();
    }
  }

  @override
  Future<String> loadFromKey(String key) async {
    final response = loadUserData();
    return response[key] as String? ?? '';
  }

  Future<List<Day>> _addExtraDays(List<Day> days) async {
    final extraDays = List<Day>.filled(
      GenerosityChallengeHelper.generosityChallengeDays - days.length,
      const Day.empty(),
    );
    days.addAll(extraDays);
    await saveToCache(days);
    return days;
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

  @override
  Future<void> clearUserData() async {
    await sharedPreferences.remove(_generosityChallengeUserDataKey);
  }

  @override
  Future<bool> isAlreadyRegistered() async {
    return sharedPreferences
            .getBool(_generosityChallengeIsAlreadyRegisteredKey) ??
        false;
  }

  @override
  Future<void> setAlreadyRegistered({required bool isAlreadyRegistered}) async {
    await sharedPreferences.setBool(
      _generosityChallengeIsAlreadyRegisteredKey,
      isAlreadyRegistered,
    );
  }
}
