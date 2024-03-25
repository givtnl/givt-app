import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/utils/utils.dart';

class UTMHelper {
  static const _utmKeys = [
    'utm_source',
    'utm_medium',
    'utm_campaign',
    'utm_term',
    'utm_content',
  ];

  static Future<void> trackToAnalytics({
    required Uri uri,
  }) async {
    final utmProperties = <String, dynamic>{};
    final queryParameters = uri.queryParameters;

    for (final key in _utmKeys) {
      if (queryParameters.containsKey(key)) {
        utmProperties[key] = queryParameters[key];
      }
    }

    if (utmProperties.isNotEmpty) {
      await AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.utm,
        eventProperties: utmProperties,
      );
    }
  }
}
