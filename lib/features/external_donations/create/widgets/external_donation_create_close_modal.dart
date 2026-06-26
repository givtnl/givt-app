import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_create_navigation.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/l10n/l10n.dart';

class ExternalDonationCreateCloseModal {
  const ExternalDonationCreateCloseModal();

  Future<void> show(BuildContext parentContext) {
    return showDialog<void>(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) => FunModal(
        icon: FunIcon.xmark(),
        title: parentContext.l10n.closeModalAreYouSure,
        subtitle: parentContext.l10n.closeModalWontBeSaved,
        buttons: [
          FunButton(
            variant: FunButtonVariant.destructive,
            onTap: () {
              Navigator.of(dialogContext).pop();
              ExternalDonationCreateNavigation.exitFlow(parentContext);
            },
            text: parentContext.l10n.closeModalYesExit,
            analyticsEvent: AnalyticsEventName
                .externalDonationsCreateCloseConfirmClicked
                .toEvent(),
          ),
          FunButton(
            variant: FunButtonVariant.secondary,
            fullBorder: true,
            onTap: () => Navigator.of(dialogContext).pop(),
            text: parentContext.l10n.closeModalNoBack,
            analyticsEvent: AnalyticsEventName
                .externalDonationsCreateCloseCancelClicked
                .toEvent(),
          ),
        ],
        closeAction: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}
