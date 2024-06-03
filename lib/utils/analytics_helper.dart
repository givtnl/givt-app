import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:givt_app/core/enums/enums.dart';

class AnalyticsHelper {
  static const String amountKey = 'amount';
  static const String goalKey = 'goal_name';
  static const String walletAmountKey = 'wallet_amount';
  static const String mediumIdKey = 'medium_id';
  static const String locationKey = 'location';
  static const String interestKey = 'all_selected_interests';
  static const String recommendedCharitiesKey = 'recommended_charities';
  static const String charityNameKey = 'charity_name';
  static const String avatarImageKey = 'avatar_image_selected';
  static const String rewardKey = 'reward';
  static const String cityKey = 'city';
  static const String dateEUKey = 'start_date_eu_format';
  static const String familyNameKey = 'family_name';

  static Amplitude? _amplitude;

  static Future<void> init(String key) async {
    _amplitude = Amplitude.getInstance();
    await _amplitude!.init(key);
    await _amplitude!.trackingSessionEvents(true);
  }

  static Future<void> logChatScriptEvent({
    required String eventName,
    Map<String, dynamic>? eventProperties,
  }) =>
      _logEvent(eventName, eventProperties);

  static Future<void> logEvent({
    required AmplitudeEvents eventName,
    Map<String, dynamic>? eventProperties,
  }) =>
      _logEvent(eventName.value, eventProperties);

  static Future<void> _logEvent(
    String eventName,
    Map<String, dynamic>? eventProperties,
  ) async {
    await _amplitude?.logEvent(
      eventName,
      eventProperties: eventProperties,
    );

    log('$eventName pressed with properties: $eventProperties');
  }

  static Future<void> setUserProperties({
    required String userId,
    required Map<String, dynamic> userProperties,
  }) async {
    await _amplitude?.setUserId(userId);
    await _amplitude?.setUserProperties(userProperties);
  }
}
