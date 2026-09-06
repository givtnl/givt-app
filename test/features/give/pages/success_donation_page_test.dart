import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/pages/success_donation_page.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/illustrations/fun_icon_givy.dart';

void main() {
  testWidgets(
    'offline confirmation shows hourglass Givy, copy, and Got it without close',
    (tester) async {
      const organisationName = 'Presbyterian Church';

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SuccessDonationPage(
            organisationName: organisationName,
          ),
        ),
      );
      await tester.pump();

      final locals = AppLocalizations.of(
        tester.element(find.byType(SuccessDonationPage)),
      );

      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byType(FunIconGivy), findsOneWidget);
      expect(
        find.image(const AssetImage('assets/images/givy_gave.png')),
        findsNothing,
      );
      expect(find.text(locals.offlineSuccessTitle), findsOneWidget);
      expect(
        find.text(locals.offlineSuccessBodyWithOrg(organisationName)),
        findsOneWidget,
      );
      expect(find.text(locals.offlineSuccessGotIt), findsOneWidget);
    },
  );
}
