import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/app_router.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/timezone.dart' as tz;

/// Navigate to the screen based on the notification payload
/// This is called when the user taps on the notification
@pragma('vm:entry-point')
Future<void> _navigateToScreen(NotificationResponse details) async {
  final payload = details.payload;
  switch (payload) {
    case 'RecurringDonation':
      await LoggingInfo.instance
          .info('Navigating to recurring donation screen');
      AppRouter.router.goNamed(Pages.recurringDonations.name);
    case 'ShowFeatureUpdate':
      await LoggingInfo.instance.info('Navigating to feature update screen');
    case 'ShowMonthlySummary':
      await LoggingInfo.instance.info('Navigating to monthly summary screen');
      AppRouter.router.goNamed(Pages.personalSummary.name);
    case 'ShowYearlySummary':
      await LoggingInfo.instance.info('Navigating to yearly summary screen');
      AppRouter.router.goNamed(Pages.personalSummary.name);
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
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.subscribeToTopic('dev');
    await FirebaseMessaging.instance.subscribeToTopic('all');
    await setupFlutterNotifications();
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
      const InitializationSettings(
        android: AndroidInitializationSettings('icon'),
        iOS: DarwinInitializationSettings(),
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
    await LoggingInfo.instance.info('Received push notification');
    await _handleNotification(customData);
  }

  Future<void> _handleNotification(Map<String, dynamic> customData) async {
    await LoggingInfo.instance.info('Handling push notification');
    if (customData['Type'] == null && customData['body'] != null) {
      await _showNotification(
        message: customData['body'] as String,
        title: customData['title'] as String,
      );
      return;
    }

    switch (customData['Type']) {
      case 'CelebrationActivated':
        await LoggingInfo.instance
            .info('CelebrationActivated Push received, starting process');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
        );
      case 'ProcessCachedGivts':
        await LoggingInfo.instance
            .info('ProcessCachedGivts Push received, starting process');
        await getIt<GivtRepository>().syncOfflineGivts();
      case 'RecurringDonationAboutToExpire':
      case 'RecurringDonationTurnCreated':
        await LoggingInfo.instance
            .info('Recurring Donation Turn Created Push received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: 'RecurringDonation',
        );
      case 'ShowFeatureUpdate':
        await LoggingInfo.instance.info('ShowFeatureUpdate received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: 'ShowFeatureUpdate',
        );
      case 'ShowMonthlySummary':
        await LoggingInfo.instance.info('ShowMonthlySummary received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: 'ShowMonthlySummary',
        );
      case 'ShowYearlySummary':
        await LoggingInfo.instance.info('ShowYearlySummary received');
        await _showNotification(
          message: customData['body'] as String,
          title: customData['title'] as String,
          payload: 'ShowYearlySummary',
        );

      default:
        if (customData['body'] != null) {
          await _showNotification(
            message: customData['body'] as String,
          );
        }
    }
  }

  @override
  void listenToForegroundNotification() {}

  Future<void> _showNotification({
    required String message,
    String payload = '',
    String? title,
  }) async {
    /// Notification id
    final id = Random().nextInt(9999 - 1000) + 1000;
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      message,
      notificationDetailsAndroid,
      payload: payload,
    );
  }

  Future<void> _scheduleNotifications({
    required String body,
    required String? title,
    required String? payload,
    required tz.TZDateTime scheduledDate,
    int? id,
  }) async {
    id ??= Random().nextInt(9999 - 1000) + 1000;

    await setupFlutterNotifications();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetailsAndroid,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
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
      await LoggingInfo.instance
          .info('Monthly summary notification already scheduled');
      return;
    }

    await _scheduleNotifications(
      id: 10,
      body: body,
      title: title,
      payload: 'ShowMonthlySummary',
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
      await LoggingInfo.instance
          .info('Yearly summary notification already scheduled');
      return;
    }

    await _scheduleNotifications(
      id: 20,
      body: body,
      title: title,
      payload: 'ShowYearlySummary',
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
