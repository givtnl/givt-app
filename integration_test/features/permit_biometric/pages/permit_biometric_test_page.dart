import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';

class PermitBiometricTestPage {

  PermitBiometricTestPage({required this.nativeTester});
  final WidgetTester nativeTester;

  // Locators
  final Finder denyButton = find.byKey(const ValueKey('PermitBiometric-Deny-Button'));
  final Finder activateButton = find.byType(CustomElevatedButton);
  final Finder progressIndicator = find.byType(CircularProgressIndicator);

  // Actions
  Future<void> tapDenyButton() async {
    await nativeTester.tap(denyButton);
    await nativeTester.pumpAndSettle();
  }

  Future<void> tapActivateButton() async {
    await nativeTester.tap(activateButton);
    await nativeTester.pumpAndSettle();
  }

  // Assertions
  Future<void> verifyDenyButtonIsVisible() async {
    expect(denyButton, findsOneWidget);
  }

  Future<void> verifyActivateButtonIsVisible() async {
    expect(activateButton, findsOneWidget);
  }

  Future<void> verifyProgressIndicatorIsVisible() async {
    expect(progressIndicator, findsOneWidget);
  }
}