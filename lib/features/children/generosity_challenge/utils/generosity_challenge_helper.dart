import 'dart:async';

import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/network/request_helper.dart';
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
    _setupNotificationChain(isDebug: isDebug);
  }

  static final notificationBodies = <String>[
    'Hi [name] family! I have a new assignment for you.',
    "Let's continue making a difference in your city. Your assignment is waiting for you.",
    'Tulsa needs you! We need to bring colour back to the city. Complete your assignment.',
    "It's never too late to make a difference. Let's finish what we started and complete your assignment.",
  ];

  static Future<void> cancelNotifications() async {
    final notificationService = getIt<NotificationService>();
    for (var i = 7000; i < 7000 + notificationBodies.length; i++) {
      unawaited(notificationService.cancelNotification(i));
    }
  }

  static void _setupNotificationChain({
    bool isDebug = false,
    String? name,
  }) {
    final now = tz.TZDateTime.now(
      tz.getLocation(isDebug ? 'Europe/Amsterdam' : 'America/Tulsa'),
    );

    final regularDays = <int>[1, 2, 4, 7];
    final debugMinutes = <int>[2, 4, 6, 8];

    final updatedNotificationBodies = notificationBodies.map((body) {
      return body.replaceAll('[name]', name ?? '');
    }).toList();

    notificationBodies
      ..clear()
      ..addAll(updatedNotificationBodies);

    // ignore: avoid_positional_boolean_parameters
    List<tz.TZDateTime> generateSchedule(List<int> intervals, bool isDebug) {
      return intervals.map((interval) {
        return isDebug
            ? tz.TZDateTime(
                now.location,
                now.year,
                now.month,
                now.day,
                now.hour,
                now.minute + interval,
              )
            : tz.TZDateTime(
                now.location,
                now.year,
                now.month,
                now.day + interval,
                16,
              );
      }).toList();
    }

    final regularSchedule = generateSchedule(regularDays, false);
    final debugSchedule = generateSchedule(debugMinutes, true);

    for (var i = 0; i < notificationBodies.length; i++) {
      final item = isDebug ? debugSchedule[i] : regularSchedule[i];
      unawaited(
        getIt<NotificationService>().scheduleGenerosityNotification(
          id: 7000 + i,
          body: notificationBodies[i],
          title: notificationTitle,
          scheduleDate: item,
        ),
      );
    }
  }

  // ignore: avoid_positional_boolean_parameters
  static void rescheduleNotificationChain({
    bool isDebug = false,
    String? name,
  }) {
    cancelNotifications();
    _setupNotificationChain(isDebug: isDebug, name: name);
  }

  static Future<void> complete() async {
    final sp = getIt<SharedPreferences>();
    await sp.setBool(_generosityChallengeActivatedKey, false);
    await sp.setBool(_generosityChallengeCompletedKey, true);
    unawaited(cancelNotifications());
  }

  static Future<void> deactivate() async {
    await getIt<SharedPreferences>()
        .setBool(_generosityChallengeActivatedKey, false);
    unawaited(cancelNotifications());
  }

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
