import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/split_bar_chart.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/theme/fun_givt_theme.dart';
import 'package:givt_app/shared/design_system/tokens/fun_givt_tokens.dart';

void main() {
  final tokens = FunGivtTokens.instance;

  Widget wrapChart({
    required Color primaryColor,
    required Color secondaryColor,
    required Color primaryLabelColor,
    required Color secondaryLabelColor,
    required Color primaryIconColor,
    required Color secondaryIconColor,
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
          data: const SplitBarData(
            primaryAmount: 60,
            secondaryAmount: 40,
            primaryFraction: 0.6,
            secondaryFraction: 0.4,
          ),
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          primaryLabelColor: primaryLabelColor,
          secondaryLabelColor: secondaryLabelColor,
          primaryIconColor: primaryIconColor,
          secondaryIconColor: secondaryIconColor,
          formatAmount: (amount) => '€${amount.toStringAsFixed(0)}',
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
    'givt vs external uses primary90 / tertiary80 fills, labels, and dots',
    (tester) async {
      await tester.pumpWidget(
        wrapChart(
          primaryColor: tokens.primary90,
          secondaryColor: tokens.tertiary80,
          primaryLabelColor: tokens.primary30,
          secondaryLabelColor: tokens.tertiary20,
          primaryIconColor: tokens.primary90,
          secondaryIconColor: tokens.tertiary80,
        ),
      );
      await tester.pumpAndSettle();

      await expectSeriesColors(
        tester,
        primaryColor: tokens.primary90,
        secondaryColor: tokens.tertiary80,
        primaryLabelColor: tokens.primary30,
        secondaryLabelColor: tokens.tertiary20,
      );
    },
  );
}
