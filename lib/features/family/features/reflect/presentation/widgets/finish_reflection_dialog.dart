import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/summary_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class FinishReflectionDialog extends StatelessWidget {
  const FinishReflectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FunModal(
      icon: const FunIcon(
        iconData: FontAwesomeIcons.flagCheckered,
        circleColor: FamilyAppTheme.highlight95,
        iconColor: FamilyAppTheme.highlight20,
      ),
      title: 'Has everyone had a chance to be generous?',
      closeAction: () {
        Navigator.of(context).pop();
      },
      buttons: [
        FunButton(
          onTap: () {
            Navigator.of(context).push(const SummaryScreen().toRoute(context));
          },
          text: 'Yes, finish',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.reflectAndShareConfirmExitClicked,
          ),
        ),
        FunButton.secondary(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: 'No, keep going',
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
