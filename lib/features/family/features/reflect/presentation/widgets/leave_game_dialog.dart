import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reflect/bloc/family_selection_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class LeaveGameDialog extends StatelessWidget {
  const LeaveGameDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return FunModal(
      icon: FunIcon.xmark(),
      title: 'Are you sure you want to leave the game?',
      closeAction: () {
        Navigator.of(context).pop();
      },
      buttons: [
        FunButton.destructive(
          onTap: () {
            getIt<FamilySelectionCubit>().emptyAllProfiles();
            Navigator.of(context).popUntil(
              ModalRoute.withName(
                FamilyPages.profileSelection.name,
              ),
            );
          },
          text: 'Leave game',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.reflectAndShareConfirmExitClicked,
          ),
        ),
        FunButton(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: 'Keep playing',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.reflectAndShareKeepPlayingClicked,
          ),
        ),
      ],
    );
  }

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: FamilyAppTheme.primary50.withOpacity(0.5),
      builder: (context) => this,
    );
  }
}
