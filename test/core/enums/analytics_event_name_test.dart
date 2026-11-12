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

  group('recurring donation step 1', () {
    test('names the list method button', () {
      expect(
        AnalyticsEventName.recurringStep1SelectOrganisationListClicked.value,
        'recurring_step1_select_organisation_list_clicked',
      );
      final event = AnalyticsEventName
          .recurringStep1SelectOrganisationListClicked
          .toEvent();
      expect(
        event.name,
        AnalyticsEventName.recurringStep1SelectOrganisationListClicked,
      );
      expect(event.parameters, isEmpty);
    });

    test('names the receiver button and keeps the organization', () {
      expect(
        AnalyticsEventName
            .recurringStep1SelectOrganisationContinueClicked
            .value,
        'recurring_step1_select_organisation_continue_clicked',
      );
      final event = AnalyticsEventName
          .recurringStep1SelectOrganisationContinueClicked
          .toEvent(
            parameters: {'organization': 'Red Cross'},
          );
      expect(
        event.name,
        AnalyticsEventName.recurringStep1SelectOrganisationContinueClicked,
      );
      expect(event.parameters['organization'], 'Red Cross');
    });
  });
}
