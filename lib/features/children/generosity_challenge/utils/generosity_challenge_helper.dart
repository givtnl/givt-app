import 'dart:async';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerosityChallengeHelper {
  static const String _generosityChallengeActivatedKey =
      'generosityChallengeActivated';

  static const String generosityChallengeKey = 'generosityChallenge';

  static const int generosityChallengeDays = 8;

  static bool get isActivated =>
      getIt<SharedPreferences>().getBool(_generosityChallengeActivatedKey) ??
      false;

  static Future<void> activate() async => getIt<SharedPreferences>()
      .setBool(_generosityChallengeActivatedKey, true);

  static Future<void> deactivate() async => getIt<SharedPreferences>()
      .setBool(_generosityChallengeActivatedKey, false);

  static void updateUrlsAndCountry() {
    const baseUrl = String.fromEnvironment('API_URL_US');
    const baseUrlAWS = String.fromEnvironment('API_URL_AWS_US');

    getIt<APIService>().updateApiUrl(baseUrl, baseUrlAWS);

    unawaited(
      getIt<SharedPreferences>().setString(
        Util.countryIso,
        Country.us.countryCode,
      ),
    );
  }
}
