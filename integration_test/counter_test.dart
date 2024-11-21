import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/app.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      // Load app widget.
      await tester.pumpWidget(const App());

      // Verify the counter starts at 0.
      await expectLater(
          find.byKey(const ValueKey('Splash-Loader')), findsOneWidget);
      await tester.pumpUntilGone(find.byKey(const ValueKey('Splash-Loader')));

      final input = find.byKey(const ValueKey('Email-Input'));
      expect(input, findsOneWidget);

      await tester.enterText(input, 'tamara+test3@givtapp.net');
      final button = find.byKey(const ValueKey('Email-Continue-Button'));
      await tester.tap(button);
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpUntilGone(find.byKey(const ValueKey('Splash-Loader')));
      await Future.delayed(const Duration(seconds: 3));
      final passwordInput = find.byKey(const ValueKey('Login-Bottomsheet-Login-Button'));
      expect(passwordInput, findsOneWidget);
      await tester.enterText(passwordInput, 'Welkom123');
      final loginButton = find.byKey(const ValueKey('Login-Bottomsheet-Login-Button'));
      await tester.tap(loginButton);
    });
  });
}

extension PumpUntilGone on WidgetTester {
  Future<void> pumpUntilGone(Finder finder,
      {Duration timeout = const Duration(seconds: 10),
      Duration interval = const Duration(milliseconds: 100)}) async {
    final stopwatch = Stopwatch()..start();
    while (any(finder)) {
      if (stopwatch.elapsed > timeout) {
        throw Exception('Widget still visible after timeout: $finder');
      }
      await pump(interval);
    }
  }
}