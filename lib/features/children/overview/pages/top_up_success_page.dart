import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/pages/models/top_up_success_uimodel.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/pages/common_success_page.dart';
import 'package:givt_app/utils/app_theme.dart';

class TopUpSuccessPage extends StatelessWidget {
  const TopUpSuccessPage({
    required this.uiModel,
    this.onClickButton,
    super.key,
  });

  final TopUpSuccessUIModel uiModel;
  final void Function()? onClickButton;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: CommonSuccessPage(
        buttonText: context.l10n.ready,
        title: context.l10n.genericSuccessTitle,
        text: context.l10n.topUpSuccessText(
          uiModel.amountWithCurrencySymbol ?? '',
        ),
        onClickButton: onClickButton,
      ),
    );
  }
}
