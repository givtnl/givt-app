import 'dart:async';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/notification/notification_service.dart';
import 'package:givt_app/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class GenerosityChallengeHelper {
  static const String _generosityChallengeActivatedKey =
      'generosityChallengeActivated';

  static const String generosityChallengeKey = 'generosityChallenge';

  static const String _generosityChallengeCompletedKey =
      'generosityChallengeCompleted';

  static const String notificationTitle = 'A message from the Mayor';

  static const int generosityChallengeDays = 8;

  static bool get isActivated =>
      getIt<SharedPreferences>().getBool(_generosityChallengeActivatedKey) ??
      false;

  static bool get isCompleted =>
      getIt<SharedPreferences>().getBool(_generosityChallengeCompletedKey) ??
      false;

  static Future<void> activate({required bool isDebug}) async {
    unawaited(
      getIt<SharedPreferences>()
          .setBool(_generosityChallengeActivatedKey, true),
    );
    _setupNotificationChain(isDebug);
  }

  static void _setupNotificationChain(bool isDebug) {
    final now = tz.TZDateTime.now(
        tz.getLocation(isDebug ? 'Europe/Amsterdam' : 'America/Tulsa'));
    final scheduledDay1 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day + 1,
      16,
    );
    final scheduledDay2 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day + 2,
      16,
    );
    final scheduledDay4 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day + 4,
      16,
    );
    final scheduledDay7 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day + 7,
      16,
    );

    final debugScheduledDay1 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 2,
    );

    final debugScheduledDay2 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 5,
    );

    final debugScheduledDay4 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 10,
    );

    final debugScheduledDay7 = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 15,
    );

    unawaited(
      getIt<NotificationService>().scheduleGenerosityNotification(
        body: '“Hi [name] family! I have a new assignment for you.”',
        title: notificationTitle,
        scheduleDate: isDebug ? debugScheduledDay1 : scheduledDay1,
      ),
    );
    unawaited(
      getIt<NotificationService>().scheduleGenerosityNotification(
        body:
            "Let's continue making a difference in [city]. Your assignment is waiting for you.",
        title: notificationTitle,
        scheduleDate: isDebug ? debugScheduledDay2 : scheduledDay2,
      ),
    );
    unawaited(
      getIt<NotificationService>().scheduleGenerosityNotification(
        body:
            'Tulsa needs you! We need to bring colour back to the city. Complete your assignment.',
        title: notificationTitle,
        scheduleDate: isDebug ? debugScheduledDay4 : scheduledDay4,
      ),
    );
    unawaited(
      getIt<NotificationService>().scheduleGenerosityNotification(
        body:
            "It's never too late to make a difference. Let's finish what we started and complete your assignment.",
        title: notificationTitle,
        scheduleDate: isDebug ? debugScheduledDay7 : scheduledDay7,
      ),
    );
  }

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

    getIt<APIService>().updateApiUrl(baseUrl, baseUrlAWS);

    unawaited(
      getIt<SharedPreferences>().setString(
        Util.countryIso,
        Country.us.countryCode,
      ),
    );
  }
}
