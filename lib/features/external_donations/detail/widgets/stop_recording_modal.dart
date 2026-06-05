import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';

class StopRecordingModal {
  const StopRecordingModal._();

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function() onConfirm,
  }) {
    final locals = context.l10n;

    return FunModal(
      title: locals.externalDonationsStopModalTitle,
      subtitle: locals.externalDonationsStopModalMessage,
      closeAction: () => context.pop(),
      buttons: [
        FunButton(
          onTap: () async {
            context.pop();
            await onConfirm();
          },
          text: locals.externalDonationsStopModalConfirm,
          analyticsEvent:
              AnalyticsEventName.externalDonationsStopConfirmClicked.toEvent(),
        ),
        FunButton(
          onTap: () => context.pop(),
          text: locals.externalDonationsStopModalCancel,
          variant: FunButtonVariant.secondary,
          analyticsEvent:
              AnalyticsEventName.externalDonationsStopCancelClicked.toEvent(),
        ),
      ],
    ).show(context, isDismissible: true);
  }
}
