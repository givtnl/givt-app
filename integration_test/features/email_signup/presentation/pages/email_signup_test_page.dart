import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../widget_tester_extension.dart';


class EmailSignupTestPage {

  EmailSignupTestPage({required this.nativeTester});
  final WidgetTester nativeTester;

  // Locators
  final Finder emailInput = find.byKey(const ValueKey('Email-Input'));
  final Finder continueButton = find.byKey(const ValueKey('Email-Continue-Button'));
  final Finder scrollable = find.byKey(const ValueKey('Email-Signup-Scrollable'));
  final Finder countryDropdown = find.byKey(const ValueKey('Country-Dropdown'));

  // Actions
  Future<void> enterEmail(String email) async {
    await nativeTester.scrollToWidgetViaKeyValues('Email-Input', 'Email-Signup-Scrollable');
    await nativeTester.enterText(emailInput, email);
    await nativeTester.pumpAndSettle();
  }

  Future<void> selectCountry(String country) async {
    await nativeTester.tap(countryDropdown);
    await nativeTester.pumpAndSettle();
    await nativeTester.tap(find.text(country));
    await nativeTester.pumpAndSettle();
  }

  Future<void> tapContinueButton() async {
    await nativeTester.tap(continueButton);
    await nativeTester.pump(const Duration(seconds: 1));
  }

  // Assertions
  Future<void> verifyEmailInputIsVisible() async {
    expect(emailInput, findsOneWidget);
  }

  Future<void> verifyContinueButtonIsVisible() async {
    expect(continueButton, findsOneWidget);
  }

  Future<void> verifyContinueButtonIsEnabled() async {
    final button = nativeTester.widget<ElevatedButton>(continueButton);
    expect(button.enabled, isTrue);
  }
}