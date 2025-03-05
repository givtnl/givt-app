import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_small_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
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
      content: const Column(
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: FamilyAppTheme.neutralVariant95,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.solidComment),
              SizedBox(width: 16),
              TitleSmallText('Personalized interactions'),
            ],
          ),
          SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 1,
            color: FamilyAppTheme.neutralVariant95,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.solidStar),
              SizedBox(width: 16),
              TitleSmallText('Tailored suggestions'),
            ],
          ),
          SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 1,
            color: FamilyAppTheme.neutralVariant95,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              FaIcon(FontAwesomeIcons.solidCalendar),
              SizedBox(width: 16),
              TitleSmallText('Smart summaries'),
            ],
          ),
        ],
      ),
      icon: FunAvatar.captainAi(
        isLarge: true,
      ),
      primaryButton: FunButton(
        onTap: () => enableClicked?.call(),
        text: 'Enable Captain Ai',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.enableCaptainAiClicked,
        ),
      ),
      secondaryButton: FunTextButton.medium(
        rightIconSize: 0,
        onTap: () => maybeLaterClicked?.call(),
        text: 'Maybe later',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.maybeLaterCaptainAiClicked,
        ),
      ),
    );
  }
}
