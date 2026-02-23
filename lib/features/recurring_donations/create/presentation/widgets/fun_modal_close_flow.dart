import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class FunModalCloseFlow extends StatelessWidget {
  const FunModalCloseFlow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FunModal(
      icon: FunIcon.xmark(),
      title: context.l10n.closeModalAreYouSure,
      subtitle: context.l10n.closeModalWontBeSaved,
      buttons: [
        FunButton(
          variant: FunButtonVariant.destructive,
          onTap: () {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.cancelClicked,
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          text: context.l10n.closeModalYesExit,
          analyticsEvent: AmplitudeEvents.cancelClicked.toEvent(),
        ),
        FunButton(
          variant: FunButtonVariant.secondary,
          fullBorder: true,
          onTap: () {
            Navigator.of(context).pop();
          },
          text: context.l10n.closeModalNoBack,
          analyticsEvent: AmplitudeEvents.backClicked.toEvent(),
        ),
      ],
      closeAction: () {
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }
}
