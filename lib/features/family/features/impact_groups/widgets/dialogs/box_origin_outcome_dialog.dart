import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';

Future<void> showBoxOrignSuccessDialog(BuildContext context, String orgName,
    {void Function()? onTap}) async {
  await FunModal(
    title: orgName,
    subtitle: 'Thanks for sharing!',
    icon: FunIcon.checkmark(),
    buttons: [
      FunButton(
        text: 'Done',
        onTap: onTap ?? () => Navigator.of(context).pop(),
        analyticsEvent:
            AnalyticsEvent(AmplitudeEvents.boxOrignSuccessDialogDone),
      ),
    ],
  ).show(context);
}

Future<void> showBoxOrignErrorDialog(BuildContext context,
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
