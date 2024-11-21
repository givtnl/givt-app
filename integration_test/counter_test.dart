import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/app.dart';

import 'widget_tester_extension.dart';

void main() {
  group('end-to-end test', () {
    testWidgets('verify EU login flow with email and password',
        (tester) async {
      // Load app widget.
      await tester.pumpWidget(const App());

      // Verify the counter starts at 0.
      await expectLater(
          find.byKey(const ValueKey('Splash-Loader')), findsOneWidget);
      final loader = find.byKey(const ValueKey('Splash-Loader'));
      await tester.pumpUntilGone(loader);

      final input = find.byKey(const ValueKey('Email-Input'));
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
      final skipButton = find.byKey(const ValueKey('PermitBiometric-Deny-Button'));
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
      await tester.pumpUntilVisible(find.byKey(const ValueKey('EU-Home-AppBar')));
    });
  });
}