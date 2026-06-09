import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/recurring_donations/detail/cubit/recurring_donation_detail_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PauseDonationConfirmationModal {
  const PauseDonationConfirmationModal._();

  static Future<void> show(
    BuildContext context, {
    required RecurringDonationDetailCubit cubit,
    required DateTime restartDate,
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
            await cubit.pauseDonation(restartDate);
          },
          text: locals.recurringDonationsPauseConfirmButton,
          isLoading: cubit.isPausing,
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
