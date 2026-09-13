import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_filters.dart';
import 'package:givt_app/features/donation_overview/widgets/donation_history_filter_sheet.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/theme/fun_givt_theme.dart';

void main() {
  testWidgets('From/To fields use a 24px solid calendar in the leading slot', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FunGivtTheme().toThemeData(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: DonationHistoryFilterSheet(
            initial: DonationHistoryFilters.empty,
          ),
        ),
      ),
    );

    expect(find.text('From'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
    expect(find.text('Select'), findsNWidgets(2));
    expect(
      find.byIcon(FontAwesomeIcons.solidCalendar.data),
      findsNWidgets(2),
    );

    final calendars = tester.widgetList<FaIcon>(
      find.byWidgetPredicate(
        (widget) =>
            widget is FaIcon &&
            widget.icon == FontAwesomeIcons.solidCalendar.data,
      ),
    );
    expect(calendars, hasLength(2));
    for (final icon in calendars) {
      expect(icon.size, 24);
    }

    final calendarBoxes = tester.widgetList<SizedBox>(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 24 && widget.height == 24,
      ),
    );
    expect(calendarBoxes.length, greaterThanOrEqualTo(2));
  });

  testWidgets('From/To show a compact numeric date instead of weekday medium', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en', 'US'),
        theme: FunGivtTheme().toThemeData(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DonationHistoryFilterSheet(
            initial: DonationHistoryFilters(
              startDate: DateTime(2026, 9, 1),
              endDate: DateTime(2026, 9, 10),
            ),
          ),
        ),
      ),
    );

    expect(find.text('9/1/2026'), findsOneWidget);
    expect(find.text('9/10/2026'), findsOneWidget);
    expect(find.textContaining('Thu'), findsNothing);
    expect(find.textContaining('Sep'), findsNothing);
  });

  testWidgets('From opens a compact calendar sheet, not the Material dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: FunGivtTheme().toThemeData(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: DonationHistoryFilterSheet(
            initial: DonationHistoryFilters.empty,
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.byType(TextField).first);
    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();

    expect(find.byType(CalendarDatePicker), findsOneWidget);
    expect(find.byType(DatePickerDialog), findsNothing);
    expect(find.text('Select date'), findsNothing);
  });
}
