import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_frequency_dropdown.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets(
    'default list includes Quarterly and selecting it calls onChanged',
    (tester) async {
      ExternalDonationFrequency? selected;

      await tester.pumpWidget(
        _wrap(
          ExternalDonationFrequencyDropdown(
            value: ExternalDonationFrequency.monthly,
            onChanged: (frequency) => selected = frequency,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('FunInputDropdown')));
      await tester.pumpAndSettle();

      expect(find.text('Quarterly'), findsOneWidget);

      await tester.tap(find.text('Quarterly').last);
      await tester.pumpAndSettle();

      expect(selected, ExternalDonationFrequency.quarterly);
    },
  );
}
