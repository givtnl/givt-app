import 'dart:async';
import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart' as get_it_injection;
import 'package:givt_app/features/family/app/injection.dart'
as get_it_injection_family;

// https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the dependency injection
  await get_it_injection.init();
  await get_it_injection_family.init();
  await get_it_injection.getIt.allReady();
  // in the future we will setup the injection of test dependencies here
  await testMain();
}
