import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class AiGameExplanationSheet extends StatelessWidget {
  const AiGameExplanationSheet({
    super.key,
    this.enableClicked,
    this.maybeLaterClicked,
  });

  final VoidCallback? enableClicked;
  final VoidCallback? maybeLaterClicked;

  @override
  Widget build(BuildContext context) {
    return FunBottomSheet(
      title: 'Captain Ai is here to help improve your conversation',
      content: const SizedBox.shrink(),
      primaryButton: FunButton(
        onTap: () => enableClicked?.call(),
        text: 'Enable Captain Ai',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.enableCaptainAiClicked,
        ),
      ),
      secondaryButton: FunButton.secondary(
        onTap: () => maybeLaterClicked?.call(),
        text: 'Maybe later',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.maybeLaterCaptainAiClicked,
        ),
      ),
    );
  }
}
