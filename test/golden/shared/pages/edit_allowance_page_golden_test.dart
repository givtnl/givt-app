import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_page.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_success_page.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/shared/pages/common_success_page.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../golden_utils.dart';
import '../../screen_sizes.dart';

// https://pub.dev/packages/golden_toolkit

void main() {
  testGoldens('Edit Allowance Page renders correctly', (tester) async {
    final builder = GoldenBuilder.column(
      bgColor: Colors.white,
      wrap: (widget) => SizedBox(
        height: 500,
        child: widget,
      ),
    )..addScenario(
        'Edit Allowance Page',
        const EditAllowancePage(
          initialAllowance: 20,
        ),
      );
    await checkIfScreenMatchesGolden(
      'edit_allowance_page_golden',
      tester,
      builder.build(),
    );
  });
}
