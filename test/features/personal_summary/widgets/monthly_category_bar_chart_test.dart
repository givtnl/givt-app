import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/monthly_category_bar_chart.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('nl');
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

  Widget wrapChart({required Locale locale}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MonthlyCategoryBarChart(
          rows: sampleRows,
          formatAmount: (amount) => '€${amount.toStringAsFixed(0)}',
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
}
