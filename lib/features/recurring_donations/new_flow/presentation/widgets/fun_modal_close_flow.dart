import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
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
        FunButton.destructive(
          onTap: () {
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.cancelClicked,
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          text: 'Yes, exit',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.cancelClicked,
          ),
        ),
        FunButton.secondary(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: 'No, go back',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.backClicked,
          ),
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
