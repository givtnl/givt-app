import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/pages/common_success_page.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';

class CancelRGASuccessPage extends StatelessWidget {
  const CancelRGASuccessPage({
    this.onClickButton,
    super.key,
  });

  final void Function()? onClickButton;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: CommonSuccessPage(
        buttonText: context.l10n.ready,
        appBarTitle: 'Recurring Amount',
        title: 'The Recurring Amount has been canceled.',
        text: 'You can set it up again at any time.',
        onClickButton: onClickButton,
        image: trashAvatarIcon(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.width * 0.35,
        ),
      ),
    );
  }
}
