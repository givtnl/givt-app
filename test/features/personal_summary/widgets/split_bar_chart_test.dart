import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/split_bar_chart.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/theme/fun_givt_theme.dart';
import 'package:givt_app/shared/design_system/tokens/fun_givt_tokens.dart';

Finder _chevronFinder() => find.byIcon(FontAwesomeIcons.chevronRight.data);

void main() {
  final tokens = FunGivtTokens.instance;

  Widget wrapChart({
    required SplitBarData data,
    Color? primaryColor,
    Color? secondaryColor,
    Color? primaryLabelColor,
    Color? secondaryLabelColor,
    Color? primaryIconColor,
    Color? secondaryIconColor,
    VoidCallback? onPrimaryTap,
    VoidCallback? onSecondaryTap,
  }) {
    return MaterialApp(
      locale: const Locale('en'),
      theme: FunGivtTheme().toThemeData(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SplitBarChart(
          title: 'Recurring vs one-off',
          subtitle: 'How much of your giving is regular',
          primaryLabel: 'Recurring',
          secondaryLabel: 'One-off',
          data: data,
          primaryColor: primaryColor ?? tokens.secondary30,
          secondaryColor: secondaryColor ?? tokens.secondary60,
          primaryLabelColor: primaryLabelColor ?? Colors.white,
          secondaryLabelColor: secondaryLabelColor ?? tokens.primary20,
          primaryIconColor: primaryIconColor ?? tokens.secondary30,
          secondaryIconColor: secondaryIconColor ?? tokens.secondary60,
          formatAmount: (amount) => '€${amount.toStringAsFixed(0)}',
          onPrimaryTap: onPrimaryTap,
          onSecondaryTap: onSecondaryTap,
        ),
      ),
    );
  }

  Future<void> expectSeriesColors(
    WidgetTester tester, {
    required Color primaryColor,
    required Color secondaryColor,
    required Color primaryLabelColor,
    required Color secondaryLabelColor,
  }) async {
    final barColors = tester
        .widgetList<ColoredBox>(find.byType(ColoredBox))
        .map((box) => box.color)
        .toList();
    expect(barColors, containsAll(<Color>[primaryColor, secondaryColor]));

    final legendColors = tester
        .widgetList<FaIcon>(find.byType(FaIcon))
        .map((icon) => icon.color)
        .toList();
    expect(legendColors, containsAll(<Color>[primaryColor, secondaryColor]));

    Color? labelColorOnBar(Color barColor) {
      final barFinder = find.byWidgetPredicate(
        (widget) => widget is ColoredBox && widget.color == barColor,
      );
      final label = tester.widget<BodySmallText>(
        find.descendant(
          of: barFinder,
          matching: find.byType(BodySmallText),
        ),
      );
      return label.color;
    }

    expect(labelColorOnBar(primaryColor), primaryLabelColor);
    expect(labelColorOnBar(secondaryColor), secondaryLabelColor);
  }

  testWidgets(
    'recurring vs one-off uses secondary30 / secondary60 fills, labels, and dots',
    (tester) async {
      await tester.pumpWidget(
        wrapChart(
          data: const SplitBarData(
            primaryAmount: 60,
            secondaryAmount: 40,
            primaryFraction: 0.6,
            secondaryFraction: 0.4,
          ),
          primaryColor: tokens.secondary30,
          secondaryColor: tokens.secondary60,
          primaryLabelColor: Colors.white,
          secondaryLabelColor: tokens.primary20,
          primaryIconColor: tokens.secondary30,
          secondaryIconColor: tokens.secondary60,
        ),
      );
      await tester.pumpAndSettle();

      await expectSeriesColors(
        tester,
        primaryColor: tokens.secondary30,
        secondaryColor: tokens.secondary60,
        primaryLabelColor: Colors.white,
        secondaryLabelColor: tokens.primary20,
      );
    },
  );

  testWidgets(
    'givt vs external uses primary90 / accent80 fills, labels, and dots',
    (tester) async {
      await tester.pumpWidget(
        wrapChart(
          data: const SplitBarData(
            primaryAmount: 50,
            secondaryAmount: 50,
            primaryFraction: 0.5,
            secondaryFraction: 0.5,
          ),
          primaryColor: tokens.primary90,
          secondaryColor: tokens.accent80,
          primaryLabelColor: tokens.primary30,
          secondaryLabelColor: tokens.accent20,
          primaryIconColor: tokens.primary90,
          secondaryIconColor: tokens.accent80,
        ),
      );
      await tester.pumpAndSettle();

      await expectSeriesColors(
        tester,
        primaryColor: tokens.primary90,
        secondaryColor: tokens.accent80,
        primaryLabelColor: tokens.primary30,
        secondaryLabelColor: tokens.accent20,
      );
    },
  );

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
