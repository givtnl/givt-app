import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/personal_summary/models/personal_summary_chart_models.dart';
import 'package:givt_app/features/personal_summary/widgets/personal_summary_category_colors.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';

void main() {
  testWidgets(
    'en-US personal summary charity card says Charity, not Non-profit',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en', 'US'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Text(categoryLabel(context, GivingCategory.charity));
              },
            ),
          ),
        ),
      );

      expect(find.text('Charity'), findsOneWidget);
      expect(find.text('Non-profit'), findsNothing);
    },
  );
}
