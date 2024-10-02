import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';

Future<void> showPreferredChurchSuccessDialog(
    BuildContext context, String churchName,
    {void Function()? onTap}) async {
  await FunModal(
    title: churchName,
    subtitle: 'Added as your church',
    icon: FunIcon.checkmark(),
    buttons: [
      FunButton(
        text: 'Done',
        onTap: onTap ?? () => Navigator.of(context).pop(),
        analyticsEvent:
            AnalyticsEvent(AmplitudeEvents.preferredChurchSuccessDialogDone),
      ),
    ],
  ).show(context);
}

Future<void> showPreferredChurchErrorDialog(BuildContext context,
    {void Function()? onTap}) async {
  await FunModal(
    title: 'Oops, something went wrong...',
    buttons: [
      FunButton(
        text: 'Retry',
        onTap: onTap ?? () => context.pop(),
        leftIcon: Icons.refresh_rounded,
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.retryClicked,
        ),
      ),
    ],
  ).show(context);
}
