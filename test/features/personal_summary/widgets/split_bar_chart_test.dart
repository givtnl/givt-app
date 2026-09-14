import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/split_bar_chart.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/design_system.dart';

Finder _chevronFinder() => find.byIcon(FontAwesomeIcons.chevronRight.data);

void main() {
  Widget wrapChart({
    required SplitBarData data,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSecondaryTap,
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SplitBarChart(
          title: 'Recurring vs one-off',
          subtitle: 'How you chose to give',
          primaryLabel: 'Recurring',
          secondaryLabel: 'One-off',
          data: data,
          primaryColor: FamilyAppTheme.secondary30,
          secondaryColor: FamilyAppTheme.primary80,
          primaryLabelColor: Colors.white,
          secondaryLabelColor: FamilyAppTheme.primary20,
          primaryIconColor: FamilyAppTheme.secondary30,
          secondaryIconColor: FamilyAppTheme.primary80,
          formatAmount: (amount) => '€${amount.toStringAsFixed(0)}',
          onPrimaryTap: onPrimaryTap,
          onSecondaryTap: onSecondaryTap,
        ),
      ),
    );
  }

  testWidgets(
    'hides chevron and disables tap on zero-value split rows',
    (tester) async {
      var primaryTaps = 0;
      var secondaryTaps = 0;
      await tester.pumpWidget(
        wrapChart(
          data: const SplitBarData(
            primaryAmount: 40,
            secondaryAmount: 0,
            primaryFraction: 1,
            secondaryFraction: 0,
          ),
          onPrimaryTap: () => primaryTaps++,
          onSecondaryTap: () => secondaryTaps++,
        ),
      );
      await tester.pumpAndSettle();

      expect(_chevronFinder(), findsOneWidget);

      final oneOffFinder = find.text('One-off');
      expect(
        find.ancestor(of: oneOffFinder, matching: find.byType(InkWell)),
        findsNothing,
      );

      await tester.tap(oneOffFinder);
      await tester.pump();
      expect(secondaryTaps, 0);

      await tester.tap(find.text('Recurring'));
      await tester.pump();
      expect(primaryTaps, 1);
    },
  );

  testWidgets(
    'keeps chevrons and taps when both split amounts are greater than zero',
    (tester) async {
      var primaryTaps = 0;
      var secondaryTaps = 0;
      await tester.pumpWidget(
        wrapChart(
          data: const SplitBarData(
            primaryAmount: 40,
            secondaryAmount: 10,
            primaryFraction: 0.8,
            secondaryFraction: 0.2,
          ),
          onPrimaryTap: () => primaryTaps++,
          onSecondaryTap: () => secondaryTaps++,
        ),
      );
      await tester.pumpAndSettle();

      expect(_chevronFinder(), findsNWidgets(2));

      await tester.tap(find.text('Recurring'));
      await tester.tap(find.text('One-off'));
      await tester.pump();
      expect(primaryTaps, 1);
      expect(secondaryTaps, 1);
    },
  );

  testWidgets(
    'hides both chevrons when split data is empty',
    (tester) async {
      var primaryTaps = 0;
      var secondaryTaps = 0;
      await tester.pumpWidget(
        wrapChart(
          data: const SplitBarData.empty(),
          onPrimaryTap: () => primaryTaps++,
          onSecondaryTap: () => secondaryTaps++,
        ),
      );
      await tester.pumpAndSettle();

      expect(_chevronFinder(), findsNothing);
      expect(
        find.ancestor(
          of: find.text('Recurring'),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(of: find.text('One-off'), matching: find.byType(InkWell)),
        findsNothing,
      );

      await tester.tap(find.text('Recurring'));
      await tester.tap(find.text('One-off'));
      await tester.pump();
      expect(primaryTaps, 0);
      expect(secondaryTaps, 0);
    },
  );
}
