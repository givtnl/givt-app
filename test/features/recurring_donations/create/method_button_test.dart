import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/widgets/method_button.dart';
import 'package:givt_app/shared/widgets/action_container.dart';

void main() {
  testWidgets('forwards the list event to the tap target', (tester) async {
    final event = AnalyticsEventName.recurringStep1SelectOrganisationListClicked
        .toEvent();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MethodButton(
            onPressed: () {},
            imagePath: 'assets/images/select_list.png',
            title: 'Select from list',
            subtitle: 'Select a cause from the list',
            analyticsEvent: event,
          ),
        ),
      ),
    );

    final container = tester.widget<ActionContainer>(
      find.byType(ActionContainer),
    );
    expect(
      container.analyticsEvent.name,
      AnalyticsEventName.recurringStep1SelectOrganisationListClicked,
    );
    expect(container.analyticsEvent.parameters, isEmpty);
  });
}
