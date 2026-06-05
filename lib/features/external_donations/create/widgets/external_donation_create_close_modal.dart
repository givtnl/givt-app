import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/l10n/l10n.dart';

class ExternalDonationCreateCloseModal {
  const ExternalDonationCreateCloseModal();

  Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => FunModal(
        icon: FunIcon.xmark(),
        title: context.l10n.closeModalAreYouSure,
        subtitle: context.l10n.closeModalWontBeSaved,
        buttons: [
          FunButton(
            variant: FunButtonVariant.destructive,
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            text: context.l10n.closeModalYesExit,
            analyticsEvent: AnalyticsEventName
                .externalDonationsCreateCloseConfirmClicked
                .toEvent(),
          ),
          FunButton(
            variant: FunButtonVariant.secondary,
            fullBorder: true,
            onTap: () => Navigator.of(context).pop(),
            text: context.l10n.closeModalNoBack,
            analyticsEvent: AnalyticsEventName
                .externalDonationsCreateCloseCancelClicked
                .toEvent(),
          ),
        ],
        closeAction: () => Navigator.of(context).pop(),
      ),
    );
  }
}
