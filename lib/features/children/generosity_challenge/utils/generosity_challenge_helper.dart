import 'dart:async';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/utils/util.dart';
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

  static Future<void> deactivate() async => getIt<SharedPreferences>()
      .setBool(_generosityChallengeActivatedKey, false);

  static void updateUrlsAndCountry() {
    const baseUrl = String.fromEnvironment('API_URL_US');
    const baseUrlAWS = String.fromEnvironment('API_URL_AWS_US');

    getIt<RequestHelper>().updateApiUrl(baseUrl, baseUrlAWS);
    getIt<RequestHelper>().country = Country.us.countryCode;

    unawaited(
      getIt<SharedPreferences>().setString(
        Util.countryIso,
        Country.us.countryCode,
      ),
    );
  }
}
