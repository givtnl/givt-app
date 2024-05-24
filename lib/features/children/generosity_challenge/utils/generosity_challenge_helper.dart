import 'package:givt_app/app/injection/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityChallengeHelper {
  static const String _generosityChallengeActivatedKey =
      'generosityChallengeActivated';

  static const String generosityChallengeKey = 'generosityChallenge';

  static const String _generosityChallengeCompletedKey =
      'generosityChallengeCompleted';

  static const int generosityChallengeDays = 8;

  static bool get isActivated =>
      getIt<SharedPreferences>().getBool(_generosityChallengeActivatedKey) ??
      false;

  static bool get isCompleted =>
      getIt<SharedPreferences>().getBool(_generosityChallengeCompletedKey) ??
      false;

  static Future<void> activate() async => getIt<SharedPreferences>()
      .setBool(_generosityChallengeActivatedKey, true);

  static Future<void> complete() async {
    final sp = getIt<SharedPreferences>();
    await sp.setBool(_generosityChallengeActivatedKey, false);
    await sp.setBool(_generosityChallengeCompletedKey, true);
  }
}
