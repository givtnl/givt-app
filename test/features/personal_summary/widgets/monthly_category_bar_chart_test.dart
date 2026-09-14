import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/monthly_category_bar_chart.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Finder _chevronFinder() => find.byIcon(FontAwesomeIcons.chevronRight.data);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('nl');
    await initializeDateFormatting('en');
  });

  const sampleRows = [
    MonthlyCategoryRow(
      month: 1,
      amountsByCategory: {GivingCategory.charity: 25},
      total: 25,
    ),
    MonthlyCategoryRow(
      month: 2,
      amountsByCategory: {GivingCategory.church: 40},
      total: 40,
    ),
  ];

  const mixedRows = [
    MonthlyCategoryRow(
      month: 1,
      amountsByCategory: {GivingCategory.charity: 25},
      total: 25,
    ),
    MonthlyCategoryRow(
      month: 2,
      amountsByCategory: {},
      total: 0,
    ),
  ];

  Widget wrapChart({
    required Locale locale,
    List<MonthlyCategoryRow> rows = sampleRows,
    ValueChanged<int>? onMonthTap,
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MonthlyCategoryBarChart(
          rows: rows,
          formatAmount: (amount) => '€${amount.toStringAsFixed(0)}',
          onMonthTap: onMonthTap,
        ),
      ),
    );
  }

  testWidgets('renders month labels using the app locale', (tester) async {
    const locale = Locale('nl');
    await tester.pumpWidget(wrapChart(locale: locale));
    await tester.pumpAndSettle();

    for (final row in sampleRows) {
      final expectedLabel = DateFormat.MMM(locale.toLanguageTag()).format(
        DateTime(2024, row.month),
      );
      expect(find.text(expectedLabel), findsOneWidget);
    }
  });

  testWidgets(
    'hides chevron and disables tap on empty month rows',
    (tester) async {
      const locale = Locale('en');
      final tapped = <int>[];
      await tester.pumpWidget(
        wrapChart(
          locale: locale,
          rows: mixedRows,
          onMonthTap: tapped.add,
        ),
      );
      await tester.pumpAndSettle();

      expect(_chevronFinder(), findsOneWidget);

      final janLabel = DateFormat.MMM(locale.toLanguageTag()).format(
        DateTime(2024, 1),
      );
      final febLabel = DateFormat.MMM(locale.toLanguageTag()).format(
        DateTime(2024, 2),
      );

      expect(
        find.ancestor(of: find.text(febLabel), matching: find.byType(InkWell)),
        findsNothing,
      );

      await tester.tap(find.text(febLabel));
      await tester.pump();
      expect(tapped, isEmpty);

      await tester.tap(find.text(janLabel));
      await tester.pump();
      expect(tapped, [1]);
    },
  );
}
