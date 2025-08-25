import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

Future<void> showBoxOriginSuccessDialog(
  BuildContext context,
  String orgName, {
  void Function()? onTap,
}) async {
  await FunModal(
    title: orgName,
    subtitle: 'Thanks for sharing!',
    icon: FunIcon.checkmark(),
    buttons: [
      FunButton(
        text: context.l10n.buttonDone,
        onTap: onTap ?? () => Navigator.of(context).pop(),
        analyticsEvent: AmplitudeEvents.boxOriginSuccessDialogDone.toEvent(),
      ),
    ],
  ).show(context);
}

Future<void> showBoxOriginErrorDialog(
  BuildContext context, {
  void Function()? onTapRetry,
  void Function()? onTapSkip,
}) async {
  await FunModal(
    title: 'Oops, something went wrong...',
    buttons: [
      FunButton(
        text: 'Retry',
        onTap: onTapRetry ?? () => context.pop(),
        leftIcon: Icons.refresh_rounded,
        analyticsEvent: AmplitudeEvents.retryClicked.toEvent(),
      ),
      FunButton.secondary(
        onTap: onTapSkip,
        text: context.l10n.buttonSkip,
        analyticsEvent: AmplitudeEvents.skipClicked.toEvent(),
      ),
    ],
  ).show(context);
}
