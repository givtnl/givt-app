import 'dart:convert';
import 'package:givt_app/features/children/generosity_challenge/models/day.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin GenerosityChallengeRepository {
  Future<void> saveToCache(List<Day> days);
  Future<List<Day>> loadFromCache();
  Future<void> clearCache();
}

class GenerosityChallengeRepositoryImpl with GenerosityChallengeRepository {
  GenerosityChallengeRepositoryImpl(
    this.sharedPreferences,
  );

  static const String _generosityChallengeDaysKey = 'generosityChallengeDays';

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
      final days = List<Day>.filled(
        GenerosityChallengeHelper.generosityChallengeDays,
        const Day.empty(),
      );
      await saveToCache(days);
      return days;
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_generosityChallengeDaysKey);
  }
}
