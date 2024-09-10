import 'dart:async';

// https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // in the future we will setup the injection of test dependencies here
  await testMain();
}
