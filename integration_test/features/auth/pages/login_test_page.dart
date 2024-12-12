import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

import '../../../widget_tester_extension.dart';
import '../../email_signup/presentation/pages/email_signup_test_page.dart';

class LoginTestPage {

  LoginTestPage({required this.nativeTester});
  final WidgetTester nativeTester;

  // Locators
  final Finder emailInput = find.byType(CustomTextFormField).at(0);
  final Finder passwordInput = find.byKey(const ValueKey('Login-Bottomsheet-Password-Input'));
  final Finder loginButton = find.byKey(const ValueKey('Login-Bottomsheet-Login-Button'));
  final Finder forgotPasswordButton = find.text('Forgot Password');

  // Actions
  Future<void> enterEmail(String email) async {
    await nativeTester.enterText(emailInput, email);
    await nativeTester.pumpAndSettle();
  }

  Future<void> enterPassword(String password) async {
    await nativeTester.pumpUntilVisible(passwordInput);
    await nativeTester.enterText(passwordInput, password);
    await nativeTester.pump(const Duration(seconds: 1));
  }

  Future<void> tapLoginButton() async {
    await nativeTester.tap(loginButton);
    await nativeTester.pumpAndSettle();
  }

  Future<void> tapForgotPasswordButton() async {
    await nativeTester.tap(forgotPasswordButton);
    await nativeTester.pumpAndSettle();
  }

  // Assertions
  Future<void> verifyEmailInputIsVisible() async {
    expect(emailInput, findsOneWidget);
  }

  Future<void> verifyPasswordInputIsVisible() async {
    expect(passwordInput, findsOneWidget);
  }

  Future<void> verifyLoginButtonIsVisible() async {
    expect(loginButton, findsOneWidget);
  }

  Future<void> verifyLoginButtonIsEnabled() async {
    final button = nativeTester.widget<ElevatedButton>(loginButton);
    expect(button.enabled, isTrue);
  }
}