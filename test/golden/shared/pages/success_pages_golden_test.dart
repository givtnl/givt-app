import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/pages/edit_allowance_success_page.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/pages/common_success_page.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../golden_utils.dart';

// https://pub.dev/packages/golden_toolkit

void main() {
  testGoldens('Success Pages render correctly', (tester) async {
    final builder = GoldenBuilder.grid(
      bgColor: Colors.white,
      columns: 2,
      widthToHeightRatio: 1,
      wrap: (widget) => SizedBox(height: 500, child: widget,),
    )
      ..addScenario(
        'Common Success Page',
        const CommonSuccessPage(
          buttonText: mediumLoremIpsum,
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
    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(
        theme: AppTheme.lightTheme,
        localizations: AppLocalizations.localizationsDelegates,
      ),
      surfaceSize: const Size(1000, 500),
    );
    await screenMatchesGolden(tester, 'success_pages_golden');
  });
}
