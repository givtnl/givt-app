import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'screen_sizes.dart';

const smallLoremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
const mediumLoremIpsum = 'Lorem ipsum dolor sit amet, consectetur adipiscing '
    'elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
const largeLoremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim '
    'veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
    'commodo consequat. Duis aute irure dolor in reprehenderit in voluptate '
    'velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
    'occaecat cupidatat non proident, sunt in culpa qui officia deserunt '
    'mollit anim id est laborum.';

WidgetWrapper goldenWrapper() => materialAppWrapper(
      theme: AppTheme.lightTheme,
      localizations: AppLocalizations.localizationsDelegates,
    );

Future<void> prepareWidgetForGolden(
  WidgetTester tester,
  Widget widget, {
  Size? size,
}) async {
  await tester.pumpWidgetBuilder(
    widget,
    wrapper: goldenWrapper(),
    surfaceSize: size ?? SurfaceSizes.oneScenarioPortrait,
  );
}

Future<void> checkIfScreenMatchesGolden(
  String goldenFileName,
  WidgetTester tester,
  Widget widget, {
  Size? size,
}) async {
  await prepareWidgetForGolden(tester, widget, size: size);
  await screenMatchesGolden(tester, goldenFileName);
}
