import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
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
      content: Column(
        children: [
          FunIcon.checkmark(),
          const SizedBox(height: 24),
          BodyMediumText(
            text,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      primaryButton: FunButton(
        text: context.l10n.buttonDone,
        analyticsEvent: AnalyticsEventName.topupDoneButtonClicked.toEvent(),
        onTap: onSuccess,
      ),
      closeAction: () {
        context.pop();
      },
    );
  }
}
