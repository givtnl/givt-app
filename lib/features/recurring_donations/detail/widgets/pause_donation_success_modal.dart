import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PauseDonationSuccessModal {
  const PauseDonationSuccessModal._();

  static Future<void> show(
    BuildContext context, {
    required DateTime restartDate,
    required VoidCallback onDone,
  }) {
    final locals = context.l10n;
    final locale = Util.getLanguageTageFromLocale(context);
    final formattedDate = DateFormat.yMMMd(locale).format(restartDate);

    return FunModal(
      icon: FunIcon.checkmark(),
      title: locals.recurringDonationsPauseSuccessTitle,
      subtitle: locals.recurringDonationsPauseSuccessMessage(formattedDate),
      buttons: [
        FunButton(
          onTap: () {
            context.pop();
            onDone();
          },
          text: locals.buttonDone,
          analyticsEvent:
              AnalyticsEventName.recurringDonationPauseSuccessDoneClicked
                  .toEvent(),
        ),
      ],
    ).show(context, isDismissible: false);
  }
}
