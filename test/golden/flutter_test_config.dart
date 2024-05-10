import 'dart:async';
import 'dart:io';

import 'package:golden_toolkit/golden_toolkit.dart';

// https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      enableRealShadows: true,
      // if a CI runs on a different machine this will cause the test to fail
      // due to pixel differences, therefore we disable the golden assertion
      // when the platform is not MacOS
      skipGoldenAssertion: () => !Platform.isMacOS,
    ),
  );
}
