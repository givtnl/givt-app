import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/category_donut_chart.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';

Finder _chevronFinder() => find.byIcon(FontAwesomeIcons.chevronRight.data);

void main() {
  const segments = [
    ChartSegment(
      category: GivingCategory.church,
      amount: 50,
      fraction: 50 / 60,
    ),
    ChartSegment(
      category: GivingCategory.charity,
      amount: 0,
      fraction: 0,
    ),
    ChartSegment(
      category: GivingCategory.campaign,
      amount: 10,
      fraction: 10 / 60,
    ),
    ChartSegment(
      category: GivingCategory.other,
      amount: 0,
      fraction: 0,
    ),
  ];

  Widget wrapChart({ValueChanged<GivingCategory>? onCategoryTap}) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: CategoryDonutChart(
          segments: segments,
          centerAmount: '€60',
          centerLabel: 'this year',
          formatAmount: (amount) => '€${amount.toStringAsFixed(0)}',
          onCategoryTap: onCategoryTap,
        ),
      ),
    );
  }

  testWidgets(
    'hides chevron and disables tap on zero-value category rows',
    (tester) async {
      final tapped = <GivingCategory>[];
      await tester.pumpWidget(
        wrapChart(onCategoryTap: tapped.add),
      );
      await tester.pumpAndSettle();

      expect(_chevronFinder(), findsNWidgets(2));

      final charityFinder = find.text('Charity');
      expect(charityFinder, findsOneWidget);
      expect(
        find.ancestor(of: charityFinder, matching: find.byType(InkWell)),
        findsNothing,
      );

      await tester.tap(charityFinder);
      await tester.pump();
      expect(tapped, isEmpty);

      await tester.tap(find.text('Church'));
      await tester.pump();
      expect(tapped, [GivingCategory.church]);
    },
  );
}
