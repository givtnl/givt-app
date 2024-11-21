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

      // // Finds the floating action button to tap on.
      // final fab = find.byKey(const ValueKey('increment'));

      // // Emulate a tap on the floating action button.
      // await tester.tap(fab);

      // // Trigger a frame.
      // await tester.pumpAndSettle();

      // // Verify the counter increments by 1.
      // expect(find.text('1'), findsOneWidget);
    });
  });
}
