import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';

import 'package:amplitude_flutter/events/base_event.dart';
import 'package:amplitude_flutter/events/identify.dart';
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

  static Amplitude? _amplitude;

  static Future<void> init(String key) async {
    final configuration = Configuration(
      apiKey: key,
    );
    _amplitude = Amplitude(configuration);
    await _amplitude!.isBuilt;
  }

  static Future<void> logChatScriptEvent({
    required String eventName,
    Map<String, dynamic>? eventProperties,
  }) =>
      _logEvent(eventName, eventProperties);

  static Future<void> logEvent({
    required AmplitudeEvents eventName,
    Map<String, dynamic>? eventProperties,
  }) {
    return _logEvent(
      eventName.value,
      eventProperties,
    );
  }

  static Future<void> _logEvent(
    String eventName,
    Map<String, dynamic>? eventProperties,
  ) async {
    final event = BaseEvent(eventName);
    if (eventProperties != null) {
      event.eventProperties = eventProperties;
    }
    await _amplitude?.track(event);

    log('$eventName pressed with event properties: $eventProperties');
  }

  static Future<void> clearUserProperties() async {
    final identify = Identify()..clearAll();
    await _amplitude?.identify(identify);
  }

  static Future<void> setUserProperties({
    required String userId,
    Map<String, dynamic>? userProperties,
  }) async {
    log('Amplitude, userId: $userId, setting user properties: $userProperties');
    await _amplitude?.setUserId(userId);
    if (userProperties != null) {
      final identify = Identify();
      userProperties.forEach((key, value) {
        identify.set(key, value);
      });
      await _amplitude?.identify(identify);
    }
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
}
