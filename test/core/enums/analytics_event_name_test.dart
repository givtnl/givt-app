import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';

void main() {
  group('AnalyticsEventName.homeFaqIconClicked', () {
    test('uses the expected PostHog event name', () {
      expect(
        AnalyticsEventName.homeFaqIconClicked.value,
        'home_faq_icon_clicked',
      );
    });

    test('builds an AnalyticsEvent without parameters', () {
      final event = AnalyticsEventName.homeFaqIconClicked.toEvent();

      expect(event.name, AnalyticsEventName.homeFaqIconClicked);
      expect(event.parameters, isEmpty);
    });
  });
}
