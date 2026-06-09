import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PauseDonationConfirmationModal {
  const PauseDonationConfirmationModal._();

  static Future<void> show(
    BuildContext context, {
    required DateTime restartDate,
    required Future<void> Function() onConfirm,
  }) {
    final locals = context.l10n;
    final locale = Util.getLanguageTageFromLocale(context);
    final formattedDate = DateFormat.yMMMd(locale).format(restartDate);

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
