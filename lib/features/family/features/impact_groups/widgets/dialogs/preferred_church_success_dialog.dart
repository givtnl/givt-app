import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

Future<void> showPreferredChurchSuccessDialog(
    BuildContext context, String churchName) async {
  return FunModal.showAsDialog(
    context,
    title: churchName,
    subtitle: 'Added as your church',
    icon: FunIcon.checkmark(),
    buttons: [
      FunButton(
        text: 'Done',
        onTap: () => Navigator.of(context).pop(),
        analyticsEvent:
            AnalyticsEvent(AmplitudeEvents.preferredChurchSuccessDialogDone),
      ),
    ],
  );
}
