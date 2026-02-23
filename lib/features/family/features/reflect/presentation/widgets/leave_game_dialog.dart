import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class LeaveGameDialog extends StatelessWidget {
  const LeaveGameDialog({super.key, this.onConfirmLeaveGame});

  final VoidCallback? onConfirmLeaveGame;

  @override
  Widget build(BuildContext context) {
    return FunModal(
      icon: FunIcon.xmark(),
      title: 'Are you sure you want to leave the game?',
      closeAction: () {
        Navigator.of(context).pop();
      },
      buttons: [
        FunButton(
          variant: FunButtonVariant.destructive,
          onTap: () {
            onConfirmLeaveGame?.call();
          },
          text: 'Leave game',
          analyticsEvent: AmplitudeEvents.reflectAndShareConfirmExitClicked
              .toEvent(),
        ),
        FunButton(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: 'Keep playing',
          analyticsEvent: AmplitudeEvents.reflectAndShareKeepPlayingClicked
              .toEvent(),
        ),
      ],
    );
  }

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: FunTheme.of(context).primary50.withValues(alpha: 0.5),
      builder: (context) => this,
    );
  }
}
