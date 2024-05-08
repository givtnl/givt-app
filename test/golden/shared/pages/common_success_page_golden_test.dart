
import 'package:flutter/material.dart';
import 'package:givt_app/shared/pages/common_success_page.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../golden_utils.dart';
import '../../screen_sizes.dart';

void main() {
  testGoldens('Common Success Page renders correctly', (tester) async {

    final builder = GoldenBuilder.column(bgColor: Colors.white)
        ..addScenario('Long text test - small phone', const CommonSuccessPage(
          buttonText: mediumLoremIpsum,
          title: smallLoremIpsum,
          text: mediumLoremIpsum,
        ),);
    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: ScreenSizes.smallPhone,
    );
    await screenMatchesGolden(tester, 'common_success_page_golden');
  });
}
