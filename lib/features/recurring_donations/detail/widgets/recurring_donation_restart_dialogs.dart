import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class RecurringDonationRestartDialogs {
  const RecurringDonationRestartDialogs._();

  static Future<void> showInactiveOrganisationDialog(
    BuildContext context, {
    required String organisationName,
  }) {
    final locals = context.l10n;

    return FunModal(
      title: locals.inactiveCollectGroupTitle,
      subtitle: locals.inactiveCollectGroupMessage,
      closeAction: () => context.pop(),
      buttons: [
        FunButton(
          onTap: () => context.pop(),
          text: locals.buttonContinue,
          analyticsEvent: AnalyticsEventName
              .recurringDonationRestartInactiveOrgContinueTapped
              .toEvent(
                parameters: {
                  'organisation_name': organisationName,
                },
              ),
        ),
      ],
    ).show(context, isDismissible: true);
  }

  static Future<void> showOrganisationNotFoundDialog(
    BuildContext context, {
    required String organisationName,
  }) {
    final locals = context.l10n;

    return FunModal(
      title: locals.recurringDonationsRestartOrganisationNotFoundTitle,
      subtitle: locals.recurringDonationsRestartOrganisationNotFoundMessage,
      closeAction: () => context.pop(),
      buttons: [
        FunButton(
          onTap: () => context.pop(),
          text: locals.buttonContinue,
          analyticsEvent: AnalyticsEventName
              .recurringDonationRestartOrgNotFoundContinueTapped
              .toEvent(
                parameters: {
                  'organisation_name': organisationName,
                },
              ),
        ),
      ],
    ).show(context, isDismissible: true);
  }
}
