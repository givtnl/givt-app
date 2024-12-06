import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../widget_tester_extension.dart';


class EmailSignupTestPage {

  EmailSignupTestPage(this.tester);
  final WidgetTester tester;

  // Locators
  final Finder emailInput = find.byKey(const ValueKey('Email-Input'));
  final Finder continueButton = find.byKey(const ValueKey('Email-Continue-Button'));
  final Finder scrollable = find.byKey(const ValueKey('Email-Signup-Scrollable'));
  final Finder countryDropdown = find.byKey(const ValueKey('Country-Dropdown'));

  // Actions
  Future<void> enterEmail(String email) async {
    await tester.scrollToWidgetViaKeyValues('Email-Input', 'Email-Signup-Scrollable');
    await tester.enterText(emailInput, email);
    await tester.pumpAndSettle();
  }

  Future<void> selectCountry(String country) async {
    await tester.tap(countryDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(country));
    await tester.pumpAndSettle();
  }

  Future<void> tapContinueButton() async {
    await tester.tap(continueButton);
    await tester.pump(const Duration(seconds: 1));
  }

  // Assertions
  Future<void> verifyEmailInputIsVisible() async {
    expect(emailInput, findsOneWidget);
  }

  Future<void> verifyContinueButtonIsVisible() async {
    expect(continueButton, findsOneWidget);
  }

  Future<void> verifyContinueButtonIsEnabled() async {
    final button = tester.widget<ElevatedButton>(continueButton);
    expect(button.enabled, isTrue);
  }
}