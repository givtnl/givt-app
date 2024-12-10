## How to run a patrol test

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
6. If you get any other error message, please contact Tamara Roep

When running a test you can press `r` to `Hot reload` the test and `R` to `Hot restart` the test, which is very convenient for quick development. 
If you need a complete reboot, press Ctrl+C and run the command from step 2 again.