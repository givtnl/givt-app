import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/overview/widgets/external_donations_empty_state.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';

void main() {
  testWidgets('shows not-processed tag above empty state title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: ExternalDonationsEmptyState()),
      ),
    );

    expect(find.text('Not processed by Givt'), findsOneWidget);
    expect(find.text('Track giving outside Givt'), findsOneWidget);
  });
}
