import 'dart:developer';

import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/shared/models/models.dart';

class AnalyticsHelper {
  static const String amountKey = 'amount';
  static const String goalKey = 'goal_name';
  static const String firstNameKey = 'first_name';
  static const String walletAmountKey = 'wallet_amount';
  static const String mediumIdKey = 'medium_id';
  static const String locationKey = 'location';
  static const String interestKey = 'all_selected_interests';
  static const String recommendedCharitiesKey = 'recommended_charities';
  static const String charityNameKey = 'charity_name';
  static const String actOfServiceNameKey = 'act_of_service_name';
  static const String avatarImageKey = 'avatar_image_selected';
  static const String rewardKey = 'reward';
  static const String cityKey = 'city';
  static const String dateEUKey = 'start_date_eu_format';
  static const String familyNameKey = 'family_name';
  static const String isFamilyAppKey = 'is_family_app';
  static const String organizationNameKey = 'organization_name';
  static const String toggleStatusKey = 'toggle_status';
  static const String contributionLevelKey = 'contribution_level';

  static bool _isInitialized = false;

  static Future<void> init(String key) async {
    if (_isInitialized) {
      return;
    }

    final config = PostHogConfig(key);
    config.host = 'https://eu.i.posthog.com';
    // Enable PostHog error tracking where it won't conflict with our existing
    // Crashlytics handlers. Flutter framework errors are already forwarded to
    // PostHog via AnalyticsHelper.logError in bootstrap.dart.
    config.errorTrackingConfig.captureFlutterErrors = false;
    config.errorTrackingConfig.capturePlatformDispatcherErrors = true;
    config.errorTrackingConfig.captureIsolateErrors = true;
    config.errorTrackingConfig.captureNativeExceptions = true; // Android only
    config.errorTrackingConfig.captureSilentFlutterErrors = false;

    await Posthog().setup(
      config,
    );
    _isInitialized = true;
  }

  static Future<void> logChatScriptEvent({
    required String eventName,
    Map<String, dynamic>? eventProperties,
  }) => _logEvent(eventName, eventProperties);

  static Future<void> logEvent({
    required AnalyticsEventName eventName,
    Map<String, dynamic>? eventProperties,
  }) {
    return _logEvent(eventName.value, eventProperties);
  }

  static Future<void> _logEvent(
    String eventName,
    Map<String, dynamic>? eventProperties,
  ) async {
    await Posthog().capture(
      eventName: eventName,
      properties: eventProperties == null
          ? null
          : Map<String, Object>.from(eventProperties),
    );

    log('$eventName pressed with event properties: $eventProperties');
  }

  static Future<void> clearUserProperties() async {
    await Posthog().reset();
  }

  static Future<void> setUserProperties({
    required String userId,
    Map<String, dynamic>? userProperties,
  }) async {
    log('PostHog, userId: $userId, setting user properties: $userProperties');

    final email = userProperties?['email'] as String?;

    if (email == null) {
      return;
    }

    final properties = <String, Object>{
      if (userProperties != null)
        ...userProperties.map(
          (key, value) => MapEntry(key, value as Object),
        ),
      'user_id': userId,
    };

    await Posthog().identify(userId: email, userProperties: properties);

    await Posthog().alias(alias: userId);
  }

  static Map<String, dynamic> getUserPropertiesFromExt(UserExt user) {
    return {
      'email': user.email,
      'profile_country': user.country,
      'first_name': user.firstName,
      'phone_number': user.phoneNumber,
      AnalyticsHelper.isFamilyAppKey: user.isUsUser,
    };
  }

  static Future<void> logError(
    Object error, {
    StackTrace? stackTrace,
    bool isFatal = false,
  }) async {
    // Avoid throwing from error logging
    try {
      final message = error.toString();
      final truncatedMessage = message.length > 500
          ? '${message.substring(0, 500)}...'
          : message;

      final stack = stackTrace?.toString();
      final truncatedStack = stack == null
          ? null
          : (stack.length > 2000 ? '${stack.substring(0, 2000)}...' : stack);

      await Posthog().capture(
        eventName: 'error_exception',
        properties: <String, Object>{
          'type': error.runtimeType.toString(),
          'message': truncatedMessage,
          if (truncatedStack != null) 'stack': truncatedStack,
          'is_fatal': isFatal,
        },
      );
    } catch (e, s) {
      log(
        'Failed to log error to PostHog: $e',
        stackTrace: s,
      );
    }
  }
}
