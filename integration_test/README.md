## How to run a specific patrol test

1. Run `flutter pub global activate patrol` in the terminal
2. To run a specific patrol test run the following command in the terminal: `patrol develop -t integration_test/eu_login_test.dart --flavor development --dart-define AMPLITUDE_KEY=ceb9aaa139ac6028aa34166d6f57923e --dart-define API_URL_US=dev-backend.givt.app --dart-define API_URL_EU=dev-backend.givtapp.net --dart-define API_URL_AWS_EU=api.development.givtapp.net --dart-define API_URL_AWS_US=api.development.givtapp.net --dart-define STRIPE_PK=pk_test_51NGl2uLM5mQffuXIiPJWhwISjD7y2tkztrobOIkxSBPUe535u3eDNEgA9ygaRSjKVqMrBdIQsowJieg5G0E5oPm100amoOlHZ1 --dart-define STRIPE_MERCHANT_ID=merchant.net.givtapp.ios.test --verbose`
Replace `eu_login_test.dart` with the test you want to run.
3. If you get a message saying something like `patrol command not found` run the following in the terminal: `path=('/Users/YOURUSER/.pub-cache/bin' $path)`
Replace `YOURUSER` with your laptop system username.
4. If you get an error message that mentions `ffi` run the following command in the terminal: `sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc`
5. If you get an error message mentioning `gems and/ or cocoapods` run the following commands in the terminal:
    - `sudo gem uninstall cocoapods`
    - `brew uninstall cocoapods`
    - `brew install cocoapods`
6. Still having issues? Delete the pubspec.lock file in the root folder. Delete the Podfile.lock file in the ios folder. 
Run `flutter clean` in the terminal. Run `flutter pub get` in the terminal. Run `cd ios` in the terminal and after that `pod install --repo-update`.
7. If none of that works, please contact Tamara

When running a test you can press `r` to `Hot reload` the test and `R` to `Hot restart` the test, which is very convenient for quick development. 
If you need a complete reboot, press Ctrl+C and run the command from step 2 again.

## How to run all patrol tests
To run a all patrol tests run the following command in the terminal: `patrol test --flavor development --dart-define AMPLITUDE_KEY=ceb9aaa139ac6028aa34166d6f57923e --dart-define API_URL_US=dev-backend.givt.app --dart-define API_URL_EU=dev-backend.givtapp.net --dart-define API_URL_AWS_EU=api.development.givtapp.net --dart-define API_URL_AWS_US=api.development.givtapp.net --dart-define STRIPE_PK=pk_test_51NGl2uLM5mQffuXIiPJWhwISjD7y2tkztrobOIkxSBPUe535u3eDNEgA9ygaRSjKVqMrBdIQsowJieg5G0E5oPm100amoOlHZ1 --dart-define STRIPE_MERCHANT_ID=merchant.net.givtapp.ios.test --verbose`

## How to create a patrol test

1. In the integration_test folder create a new dart file with the name of the test you want to create and make sure it ends in `test`. 
2. For example: `my_new_test.dart`
3. Copy the following and paste it into the file:
```
import 'package:patrol/patrol.dart';

import 'flutter_test_config.dart';
import 'widget_tester_extension.dart';

void main() {
  patrolTest('write what your test case does here',
          (patrolTester) async {
        await doTestSetup();
        final tester = patrolTester.tester;
        await tester.startApp();

        // Write your test code here
      });
}
```

You can now write your test and take advantage of native automation using patrol: https://patrol.leancode.co/documentation/native/overview
   (Note that in the documentation they've named the PatrolIntegrationTester `$` in the code while in my example it is named `patrolTester`)