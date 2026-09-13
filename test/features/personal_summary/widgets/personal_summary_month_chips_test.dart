import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_month_chips.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/theme/fun_givt_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  testWidgets('renders twelve single-select month chips', (tester) async {
    const locale = Locale('en');
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        theme: FunGivtTheme().toThemeData(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: PersonalSummaryMonthChips(
            selectedMonth: 1,
            onMonthPressed: _noop,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (var month = 1; month <= 12; month++) {
      final label = DateFormat.MMM(locale.toLanguageTag()).format(
        DateTime(2024, month),
      );
      expect(find.text(label), findsOneWidget);
    }
  });
}

void _noop(int month) {}
