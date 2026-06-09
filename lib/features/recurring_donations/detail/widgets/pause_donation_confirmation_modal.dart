import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class PauseDonationConfirmationModal {
  const PauseDonationConfirmationModal._();

  static Future<void> show(
    BuildContext context, {
    required DateTime restartDate,
    required Future<void> Function() onConfirm,
  }) {
    final locals = context.l10n;
    final formattedDate =
        MaterialLocalizations.of(context).formatMediumDate(restartDate);

    return FunModal(
      title: locals.recurringDonationsPauseConfirmTitle,
      subtitle: locals.recurringDonationsPauseConfirmMessage(formattedDate),
      closeAction: () => context.pop(),
      buttons: [
        FunButton(
          onTap: () async {
            context.pop();
            await onConfirm();
          },
          text: locals.recurringDonationsPauseConfirmButton,
          analyticsEvent:
              AnalyticsEventName.recurringDonationPauseConfirmClicked.toEvent(),
        ),
        FunButton(
          onTap: () => context.pop(),
          text: locals.recurringDonationsPauseCancelButton,
          variant: FunButtonVariant.secondary,
          analyticsEvent:
              AnalyticsEventName.recurringDonationPauseCancelClicked.toEvent(),
        ),
      ],
    ).show(context, isDismissible: true);
  }
}
