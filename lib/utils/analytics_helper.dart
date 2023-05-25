import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:givt_app/core/enums/enums.dart';

class AnalyticsHelper {
  static Amplitude? _amplitude;

  static Future<void> init(String key) async {
    _amplitude = Amplitude.getInstance();
    await _amplitude!.init(key);
    await _amplitude!.enableCoppaControl();
    await _amplitude!.trackingSessionEvents(true);
  }

  static Future<void> logEvent({
    required AmplitudeEvents eventName,
    Map<String, dynamic>? eventProperties,
  }) async {
    await _amplitude?.logEvent(
      eventName.value,
      eventProperties: eventProperties,
    );

    log('${eventName.value} pressed with properties: $eventProperties');
  }
}
