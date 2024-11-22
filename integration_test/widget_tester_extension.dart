
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpUntilVisible(Finder finder,
      {Duration timeout = const Duration(seconds: 10),
        Duration interval = const Duration(milliseconds: 100)}) async {
    final stopwatch = Stopwatch()..start();
    while (!any(finder)) {
      if (stopwatch.elapsed > timeout) {
        throw Exception('Widget still not visible after timeout: $finder');
      }
      await pump(interval);
    }
  }

  Future<void> pumpUntilGone(Finder finder,
      {Duration timeout = const Duration(seconds: 10),
        Duration interval = const Duration(milliseconds: 100)}) async {
    final stopwatch = Stopwatch()..start();
    while (any(finder)) {
      if (stopwatch.elapsed > timeout) {
        throw Exception('Widget still visible after timeout: $finder');
      }
      await pump(interval);
    }
  }
}
