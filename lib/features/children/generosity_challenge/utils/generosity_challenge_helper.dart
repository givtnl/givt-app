import 'package:givt_app/app/injection/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityChallengeHelper {
  static const String _generosityChallengeActivatedKey =
      'generosityChallengeActivated';

  static const int generosityChallengeDays = 7;

  static bool get isActivated =>
      getIt<SharedPreferences>().getBool(_generosityChallengeActivatedKey) ??
      false;

  static Future<void> activate() async => getIt<SharedPreferences>()
      .setBool(_generosityChallengeActivatedKey, true);
}
