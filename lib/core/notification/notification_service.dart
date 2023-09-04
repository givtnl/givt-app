import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

mixin INotificationService {
  Future<void> init();

  Future<void> silentNotification(Map<String, dynamic> customData);

  void listenToForegroundNotification();
}

class NotificationService implements INotificationService {
  factory NotificationService() => _singleton;

  NotificationService._internal();

  static final NotificationService _singleton = NotificationService._internal();

  static NotificationService get instance => _singleton;

  @override
  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.subscribeToTopic('dev');
    await FirebaseMessaging.instance.subscribeToTopic('all');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await LoggingInfo.instance.info('Received push notification');
      await _handleNotification(message.data);
    });
  }

  @override
  Future<void> silentNotification(Map<String, dynamic> customData) async {
    await _handleNotification(customData);
  }

  Future<void> _handleNotification(Map<String, dynamic> customData) async {
    await LoggingInfo.instance.info('Handling push notification');
    if (customData['Type'] == null && customData['body'] != null) {
      _showNotification(customData);
      return;
    }

    switch (customData['Type']) {
      case 'CelebrationActivated':
        await LoggingInfo.instance
            .info('CelebrationActivated Push received, starting process');
      case 'ProcessCachedGivts':
        await LoggingInfo.instance
            .info('ProcessCachedGivts Push received, starting process');
        await getIt<GivtRepository>().syncOfflineGivts();
      case 'RecurringDonationAboutToExpire':
      case 'RecurringDonationTurnCreated':
        await LoggingInfo.instance
            .info('Recurring Donation Turn Created Push received');
      case 'ShowFeatureUpdate':
        await LoggingInfo.instance.info('ShowFeatureUpdate received');
      case 'ShowMonthlySummary':
        await LoggingInfo.instance.info('ShowMonthlySummary received');
      case 'ShowYearlySummary':
        await LoggingInfo.instance.info('ShowYearlySummary received');

      default:
        if (customData['body'] != null) {
          _showNotification(
            customData['body'] as Map<String, dynamic>,
          );
        }
    }
  }

  @override
  void listenToForegroundNotification() {}

  void _showNotification(Map<String, dynamic> customData) {
    //TODO implement here local notification package
  }
}
