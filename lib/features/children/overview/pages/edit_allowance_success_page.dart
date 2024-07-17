import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/pages/models/edit_allowance_success_uimodel.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/pages/common_success_page.dart';
import 'package:givt_app/utils/app_theme.dart';

class EditAllowanceSuccessPage extends StatelessWidget {
  const EditAllowanceSuccessPage({
    required this.uiModel,
    super.key,
  });

  final EditAllowanceSuccessUIModel uiModel;

  @override
  Widget build(BuildContext context) {
    final child = uiModel.isMultipleChildren ? 'children' : 'child';
    return Theme(
      data: AppTheme.lightTheme,
      child: CommonSuccessPage(
        buttonText: context.l10n.ready,
        title: context.l10n.genericSuccessTitle,
        appBarTitle: 'Recurring Amount',
        text:
            'Your $child will receive ${uiModel.amountWithCurrencySymbol} each month.',
        onClickButton: uiModel.onClickButton,
      ),
    );
  }
}
