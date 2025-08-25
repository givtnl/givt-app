import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:go_router/go_router.dart';

class TopupSuccessBottomSheet extends StatelessWidget {
  const TopupSuccessBottomSheet({
    required this.topupAmount,
    required this.recurring,
    required this.onSuccess,
    super.key,
  });

  final int topupAmount;
  final bool recurring;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    var text = "\$$topupAmount has been added to your child's Wallet";
    if (recurring) {
      text += ' and your recurring amount has been setup';
    }

    return FunBottomSheet(
      title: 'Consider it done!',
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.check,
        iconSize: 48,
      ),
      content: Column(
        children: [
          BodyMediumText(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: FunButton(
        text: context.l10n.buttonDone,
        analyticsEvent: AmplitudeEvents.topupDoneButtonClicked.toEvent(),
        onTap: onSuccess,
      ),
      closeAction: () {
        context.pop();
      },
    );
  }
}
