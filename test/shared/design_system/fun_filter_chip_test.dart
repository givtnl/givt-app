import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/shared/design_system/components/content/fun_filter_chip.dart';
import 'package:givt_app/shared/design_system/theme/fun_givt_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: FunGivtTheme().toThemeData(),
    home: Scaffold(body: child),
  );
}

AnalyticsEvent get _event =>
    AnalyticsEvent(AnalyticsEventName.donationHistoryFilterChipClicked);

void main() {
  testWidgets('single-select selected state has fill and no checkmark', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        FunFilterChip(label: 'One-off', selected: true, analyticsEvent: _event),
      ),
    );

    expect(find.text('One-off'), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.check.data), findsNothing);
    expect(find.byIcon(FontAwesomeIcons.chevronDown.data), findsNothing);
    final text = tester.widget<Text>(find.text('One-off'));
    expect(text.style?.height, 1.1);
    expect(
      tester.getSize(find.byType(AnimatedContainer)).height,
      inInclusiveRange(30, 36),
    );
  });

  testWidgets('chip keeps Figma height inside a taller filter row', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          height: 60,
          width: 200,
          child: Align(
            child: FunFilterChip(label: 'Jan', analyticsEvent: _event),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(AnimatedContainer)).height,
      inInclusiveRange(30, 36),
    );
  });

  testWidgets('multi-select selected state shows a leading checkmark', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        FunFilterChip(
          mode: FunFilterChipMode.multiSelect,
          label: 'Church',
          selected: true,
          analyticsEvent: _event,
        ),
      ),
    );

    expect(find.byIcon(FontAwesomeIcons.check.data), findsOneWidget);
  });

  testWidgets('dropdown mode shows a chevron instead of toggling in place', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        FunFilterChip(
          mode: FunFilterChipMode.dropdown,
          label: 'Donation source',
          selected: false,
          analyticsEvent: _event,
        ),
      ),
    );

    expect(find.byIcon(FontAwesomeIcons.chevronDown.data), findsOneWidget);
    expect(find.byIcon(FontAwesomeIcons.check.data), findsNothing);
  });

  testWidgets('dropdown expanded state flips the chevron up', (tester) async {
    await tester.pumpWidget(
      _wrap(
        FunFilterChip(
          mode: FunFilterChipMode.dropdown,
          label: 'Donation source',
          selected: true,
          isExpanded: true,
          analyticsEvent: _event,
        ),
      ),
    );

    expect(find.byIcon(FontAwesomeIcons.chevronUp.data), findsOneWidget);
  });
}
