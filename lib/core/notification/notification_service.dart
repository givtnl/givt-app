import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/app_router.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

/// Navigate to the screen based on the notification payload
/// This is called when the user taps on the notification
@pragma('vm:entry-point')
Future<void> _navigateToScreen(NotificationResponse details) async {
  final payload = details.payload;
  if (payload == null) {
    return;
  }
  final decodedPayload = jsonDecode(payload) as Map<String, dynamic>;
  final type = decodedPayload['Type'];
  switch (type) {
    case 'RecurringDonation':
      LoggingInfo.instance.info('Navigating to recurring donation screen');
      AppRouter.router.goNamed(
        Pages.recurringDonations.name,
        queryParameters: {
          'RecurringDonationId': decodedPayload['RecurringDonationId'],
          'Organisation': decodedPayload['Organisation'],
        },
      );
    case 'ShowFeatureUpdate':
      LoggingInfo.instance.info('Navigating to feature update screen');
    case 'ShowMonthlySummary':
      LoggingInfo.instance.info('Navigating to monthly summary screen');
      AppRouter.router.goNamed(Pages.personalSummary.name);
    case 'ShowYearlySummary':
      LoggingInfo.instance.info('Navigating to yearly summary screen');
      AppRouter.router.goNamed(Pages.personalSummary.name);
    case 'GenerosityChallenge':
      LoggingInfo.instance.info('Navigating to generosity challenge screen');
      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.openedGenerosityChallengeNotification,
        eventProperties: {
          'notification id': details.id,
        },
      );
      AppRouter.router.goNamed(FamilyPages.generosityChallenge.name);
  }
}

mixin INotificationService {
  Future<void> init();

  Future<void> silentNotification(Map<String, dynamic> customData);

  void listenToForegroundNotification();

  Future<void> scheduleMonthlySummaryNotification({
    required String body,
    required String title,
  });

  Future<void> scheduleGenerosityNotification({
    required int id,
    required String body,
    required String title,
    required tz.TZDateTime scheduleDate,
  });

  Future<void> scheduleYearlySummaryNotification({
    required String body,
    required String title,
  });
}

class NotificationService implements INotificationService {
  factory NotificationService() => _singleton;

  NotificationService._internal();

  static final NotificationService _singleton = NotificationService._internal();

  static NotificationService get instance => _singleton;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Notification Details for Android
  NotificationDetails get notificationDetailsAndroid => NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'icon',
        ),
      );

  @override
  Future<void> init() async {
    await FirebaseMessaging.instance.subscribeToTopic('dev');
    await FirebaseMessaging.instance.subscribeToTopic('all');
    await setupFlutterNotifications();

    // When the app is launched from a notification
    final notificationAppLaunchDetails = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp &&
        notificationAppLaunchDetails.notificationResponse != null) {
      await _navigateToScreen(
        notificationAppLaunchDetails.notificationResponse!,
      );
    }
  }

  Future<void> navigateFirebaseNotification(RemoteMessage message) async {
    LoggingInfo.instance.info('Firebase notification received');
    print('Firebase notification received');

    switch (message.data['Type']) {
      case 'DonationApproval':
        LoggingInfo.instance.info('Navigating to family overview screen');
        AppRouter.router.goNamed(FamilyPages.childrenOverview.name);
    }
  }

  Future<void> setupFlutterNotifications() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('icon'),
        iOS: DarwinInitializationSettings(
          onDidReceiveLocalNotification: (id, title, body, payload) async =>
              _navigateToScreen(
            NotificationResponse(
              payload: payload,
              notificationResponseType:
                  NotificationResponseType.selectedNotification,
            ),
          ),
        ),
      ),
      onDidReceiveBackgroundNotificationResponse: _navigateToScreen,
      onDidReceiveNotificationResponse: _navigateToScreen,
    );

    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  Future<void> silentNotification(Map<String, dynamic> customData) async {
    LoggingInfo.instance.info('Received push notification');
    await _handleNotification(customData);
  }

  Future<void> _handleNotification(Map<String, dynamic> customData) async {
    LoggingInfo.instance.info('Handling push notification');
    if (customData['Type'] == null && customData['body'] != null) {
      await _showNotification(
        message: customData['body'] as String,
        title: customData['title'] as String,
      );
      return;
    }

    switch (customData['Type']) {
      case 'CelebrationActivated':
        LoggingInfo.instance
            .info('CelebrationActivated Push received, starting process');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
        );
      case 'ProcessCachedGivts':
        LoggingInfo.instance
            .info('ProcessCachedGivts Push received, starting process');
        await getIt<GivtRepository>().syncOfflineGivts();
      case 'RecurringDonationAboutToExpire':
      case 'RecurringDonationTurnCreated':
        LoggingInfo.instance
            .info('Recurring Donation Turn Created Push received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: {
            'Type': 'RecurringDonation',
            'RecurringDonationId': customData['RecurringDonationId'],
            'Organisation': customData['Organisation'],
          },
        );
      case 'ShowFeatureUpdate':
        LoggingInfo.instance.info('ShowFeatureUpdate received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: {'Type': 'ShowFeatureUpdate'},
        );
      case 'ShowMonthlySummary':
        LoggingInfo.instance.info('ShowMonthlySummary received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: {'Type': 'ShowMonthlySummary'},
        );
      case 'ShowYearlySummary':
        LoggingInfo.instance.info('ShowYearlySummary received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: {'Type': 'ShowYearlySummary'},
        );
      case 'GenerosityChallenge':
        LoggingInfo.instance.info('GenerosityChallenge received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: {'Type': 'GenerosityChallenge'},
        );
    }
  }

  @override
  void listenToForegroundNotification() {}

  Future<void> _showNotification({
    required String message,
    Map<String, dynamic> payload = const {},
    String? title,
  }) async {
    /// Notification id
    final id = Random().nextInt(9999 - 1000) + 1000;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      message,
      notificationDetailsAndroid,
      payload: jsonEncode(payload),
    );
  }

  Future<void> _scheduleNotifications({
    required String body,
    required String? title,
    required Map<String, dynamic>? payload,
    required tz.TZDateTime scheduledDate,
    int? id,
  }) async {
    bool isSummaryNotification() =>
        payload != null &&
        (payload.containsValue('ShowMonthlySummary') ||
            payload.containsValue('ShowYearlySummary'));

    // //do not schedule summary notifications while generosity challenge is active
    if (GenerosityChallengeHelper.isActivated && isSummaryNotification()) {
      return;
    }

    id ??= Random().nextInt(9999 - 1000) + 1000;

    await setupFlutterNotifications();

    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;

        // Java Datetime support only working for Android 8+
        // So we will not schedule notifications for Android 7 and below
        if (androidInfo.version.sdkInt <= 25) return;
      } catch (e) {
        LoggingInfo.instance.error('Error getting Android version: $e');
        return;
      }
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetailsAndroid,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: jsonEncode(payload),
      );
    } catch (e) {
      LoggingInfo.instance.error('Error scheduling notification: $e');
    }
  }

  Future<bool> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
      return true;
    } catch (e) {
      LoggingInfo.instance.error('Error cancelling notification: $e');
      return false;
    }
  }

  @override
  Future<void> scheduleGenerosityNotification({
    required int id,
    required String body,
    required String title,
    required tz.TZDateTime scheduleDate,
  }) async {
    await _scheduleNotifications(
      id: id,
      body: body,
      title: title,
      payload: {'Type': 'GenerosityChallenge'},
      scheduledDate: scheduleDate,
    );
  }

  @override
  Future<void> scheduleMonthlySummaryNotification({
    required String body,
    required String title,
  }) async {
    final scheduledDate = _getNextIteration();

    if (!await _shouldScheduleNotification(
      proposedScheduleDate: scheduledDate,
      prefKey: monthlySummaryNotificationKey,
    )) {
      LoggingInfo.instance
          .info('Monthly summary notification already scheduled');
      return;
    }

    await _scheduleNotifications(
      id: 10,
      body: body,
      title: title,
      payload: {'Type': 'ShowMonthlySummary'},
      scheduledDate: scheduledDate,
    );
  }

  @override
  Future<void> scheduleYearlySummaryNotification({
    required String body,
    required String title,
  }) async {
    final scheduledDate = _getNextIteration(isMonthly: false);

    if (!await _shouldScheduleNotification(
      proposedScheduleDate: scheduledDate,
      prefKey: yearlySummaryNotificationKey,
    )) {
      LoggingInfo.instance
          .info('Yearly summary notification already scheduled');
      return;
    }

    await _scheduleNotifications(
      id: 20,
      body: body,
      title: title,
      payload: {'Type': 'ShowYearlySummary'},
      scheduledDate: scheduledDate,
    );
  }

  /// Schedule a notification that specifies the date and time at which the
  /// notification should first be delivered.
  Future<bool> _shouldScheduleNotification({
    required String prefKey,
    required tz.TZDateTime proposedScheduleDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final lastScheduledDate = prefs.getString(prefKey);

    if (lastScheduledDate == null) {
      return true;
    }

    final lastScheduledDateParsed = tz.TZDateTime.parse(
      tz.local,
      lastScheduledDate,
    );

    if (lastScheduledDateParsed.isBefore(proposedScheduleDate)) {
      return true;
    }
    await prefs.setString(
      monthlySummaryNotificationKey,
      proposedScheduleDate.toString(),
    );
    return false;
  }

  /// Get the next iteration of the monthly/yearly [tz.TZDateTime]
  tz.TZDateTime _getNextIteration({
    bool isMonthly = true,
  }) {
    final now = tz.TZDateTime.now(tz.local);
    if (kDebugMode) {
      return now.add(const Duration(seconds: 30));
    }

    if (isMonthly) {
      var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, 25, 20);

      if (scheduledDate.isBefore(now)) {
        scheduledDate =
            tz.TZDateTime(tz.local, now.year, now.month + 1, 25, 20);
      }
      return scheduledDate;
    }
    var scheduledDate = tz.TZDateTime(tz.local, now.year, 11, 10, 20);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, now.year + 1, 11, 10, 20);
    }

    return scheduledDate;
  }

  /// Constants for notification keys used in [SharedPreferences]
  static const monthlySummaryNotificationKey = 'monthy_summary_notification';
  static const yearlySummaryNotificationKey = 'yearly_summary_notification';
}
