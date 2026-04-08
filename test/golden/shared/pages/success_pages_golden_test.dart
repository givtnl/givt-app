import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/features/family/features/overview/pages/edit_allowance_success_page.dart';
import 'package:givt_app/features/family/features/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/shared/pages/common_success_page.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../golden_utils.dart';
import '../../screen_sizes.dart';

// https://pub.dev/packages/golden_toolkit

void main() {
  setUpAll(() async {
    if (!getIt.isRegistered<AppConfig>()) {
      PackageInfo.setMockInitialValues(
        appName: 'Givt',
        packageName: 'com.givt.test',
        version: '0.0.0',
        buildNumber: '0',
        buildSignature: '',
      );
      getIt.registerSingleton(AppConfig());
    }
  });

  testGoldens('Success Pages render correctly', (tester) async {
    final builder = GoldenBuilder.column(
      bgColor: Colors.white,
      //this wrap is not always needed but i want my columns to expand to a
      // certain height so we can check if the spaceBetween property works
      wrap: (widget) => SizedBox(
        height: 500,
        child: widget,
      ),
    )
      ..addScenario(
        'Common Success Page',
        const CommonSuccessPage(
          buttonText: 'Done',
          title: smallLoremIpsum,
          text: mediumLoremIpsum,
        ),
      )
      ..addScenario(
        'Edit Allowance Success Page',
        const EditAllowanceSuccessPage(
          uiModel:
              EditAllowanceSuccessUIModel(amountWithCurrencySymbol: r'$15'),
        ),
      );
    await checkIfScreenMatchesGolden(
      'success_pages_golden',
      tester,
      builder.build(),
      size: SurfaceSizes.twoScenariosPortrait,
    );
  });
}
