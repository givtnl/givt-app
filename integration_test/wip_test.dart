import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/app.dart';

import 'find_utils.dart';
import 'widget_tester_extension.dart';

/*
flutter test integration_test/eu_login_test.dart --flavor development --dart-define AMPLITUDE_KEY=ceb9aaa139ac6028aa34166d6f57923e --dart-define API_URL_US=dev-backend.givt.app --dart-define API_URL_EU=dev-backend.givtapp.net --dart-define API_URL_AWS_EU=api.development.givtapp.net --dart-define API_URL_AWS_US=api.development.givtapp.net --dart-define STRIPE_PK=pk_test_51NGl2uLM5mQffuXIiPJWhwISjD7y2tkztrobOIkxSBPUe535u3eDNEgA9ygaRSjKVqMrBdIQsowJieg5G0E5oPm100amoOlHZ1 --dart-define STRIPE_MERCHANT_ID=merchant.net.givtapp.ios.test
 */

void main() {
  group('wip test', () {
    testWidgets('test some testing stuff', (tester) async {
      await tester.pumpWidget(const App());

      await expectLater(
          find.byKey(const ValueKey('Splash-Loader')), findsOneWidget);
      final loader = find.byKey(const ValueKey('Splash-Loader'));
      await tester.pumpUntilGone(loader);

      final input = find.byKey(const ValueKey('Email-Input'));
      await tester.scrollToWidgetViaKeyValues('Email-Input', 'Email-Signup-Scrollable');
      expect(input, findsOneWidget);

      await tester.enterText(input, 'tamara+test3@givtapp.net');
      await tester.pumpAndSettle();
      final button = find.byKey(const ValueKey('Email-Continue-Button'));
      await tester.tap(button);
      await tester.pump(const Duration(seconds: 1));
      final passwordInput =
          find.byKey(const ValueKey('Login-Bottomsheet-Password-Input'));
      await tester.pumpUntilVisible(passwordInput);
      expect(passwordInput, findsOneWidget);
      await tester.enterText(passwordInput, 'Welkom123');
      await tester.pump(const Duration(seconds: 1));
      final loginButton =
          find.byKey(const ValueKey('Login-Bottomsheet-Login-Button'));
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      final skipButton =
          find.byKey(const ValueKey('PermitBiometric-Deny-Button'));
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
      await tester
          .pumpUntilVisible(find.byKey(const ValueKey('EU-Home-AppBar')));
    });
  });
}
