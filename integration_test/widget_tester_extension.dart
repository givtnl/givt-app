import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/app.dart';

import 'find_utils.dart';

extension WidgetTesterExtension on WidgetTester {

  Future<void> startApp() async {
    await pumpWidget(const App());
  }

  Future<void> makeSureLoadersHaveFinishedLoading() async {
    await expectLater(
        find.byKey(const ValueKey('Splash-Loader')), findsOneWidget);
    final loader = find.byKey(const ValueKey('Splash-Loader'));
    await pumpUntilGone(loader);
  }

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

  // scroll to a widget by passing a finder for the widget we want to scroll to
  // and a finder for the scrollable that we need to scroll in order to get there
  // pixelsPerScroll is the amount of pixels we want to scroll each time we perform a scroll action
  Future<void> scrollToWidget(
    Finder widget,
    Finder scrollable, {
    double pixelsPerScroll = 100,
  }) async {
    return scrollUntilVisible(widget, pixelsPerScroll, scrollable: scrollable);
  }

  Future<void> scrollToWidgetViaKeys(
    Key widget,
    Key scrollable, {
    double pixelsPerScroll = 100,
  }) async {
    final widgetFinder = find.byKey(widget);
    final scrollableFinder = findScrollableByKey(scrollable);
    return scrollToWidget(
      widgetFinder,
      scrollableFinder,
      pixelsPerScroll: pixelsPerScroll,
    );
  }

  Future<void> scrollToWidgetViaKeyValues(
    String widgetKeyValue,
    String scrollableKeyValue, {
    double pixelsPerScroll = 100,
  }) async {
    return scrollToWidgetViaKeys(
      ValueKey(widgetKeyValue),
      ValueKey(scrollableKeyValue),
      pixelsPerScroll: pixelsPerScroll,
    );
  }
}
