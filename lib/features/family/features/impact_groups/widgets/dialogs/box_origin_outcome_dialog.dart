import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
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
        analyticsEvent: AnalyticsEventName.boxOriginSuccessDialogDone.toEvent(),
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
        leftIcon: FontAwesomeIcons.arrowsRotate,
        analyticsEvent: AnalyticsEventName.retryClicked.toEvent(),
      ),
      FunButton(
        variant: FunButtonVariant.secondary,
        fullBorder: true,
        onTap: onTapSkip,
        text: context.l10n.buttonSkip,
        analyticsEvent: AnalyticsEventName.skipClicked.toEvent(),
      ),
    ],
  ).show(context);
}
