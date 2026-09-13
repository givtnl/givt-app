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
}
