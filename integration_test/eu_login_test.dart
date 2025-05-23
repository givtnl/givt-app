import 'package:patrol/patrol.dart';

import 'features/auth/pages/login_test_page.dart';
import 'features/email_signup/presentation/pages/email_signup_test_page.dart';
import 'features/give/pages/home_test_page.dart';
import 'features/permit_biometric/pages/permit_biometric_test_page.dart';
import 'flutter_test_config.dart';
import 'widget_tester_extension.dart';

void main() {
  patrolTest('verify EU login flow with email and password',
      (patrolTester) async {
    await doTestSetup();
    final nativeTester = patrolTester.tester;
    await nativeTester.startApp();
    await nativeTester.makeSureLoadersHaveFinishedLoading();

    final emailSignupPage = EmailSignupTestPage(nativeTester: nativeTester);
    final loginPage = LoginTestPage(nativeTester: nativeTester);
    final permitBiometricPage =
    PermitBiometricTestPage(nativeTester: nativeTester);
    final homePage = HomeTestPage(nativeTester: nativeTester);


    await emailSignupPage.verifyEmailInputIsVisible();
    await emailSignupPage.enterEmail('tamara+test3@givtapp.net');
    await emailSignupPage.tapContinueButton();

    await loginPage.verifyPasswordInputIsVisible();
    await loginPage.enterPassword('Welkom123');
    await loginPage.tapLoginButton();

    await permitBiometricPage.verifyDenyButtonIsVisible();
    await permitBiometricPage.tapDenyButton();

    await homePage.verifyAppBarIsVisible();

    if (await patrolTester.native
        .isPermissionDialogVisible(timeout: const Duration(seconds: 5))) {
      await patrolTester.native.grantPermissionWhenInUse();
    }
  });
}
