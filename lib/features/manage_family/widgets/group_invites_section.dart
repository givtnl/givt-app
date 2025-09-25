import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/manage_family/models/group_invite.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class GroupInvitesSection extends StatelessWidget {
  const GroupInvitesSection({
    required this.invites,
    required this.onInviteTap,
    required this.onAcceptInvite,
    required this.onDeclineInvite,
    super.key,
  });

  final List<GroupInvite> invites;
  final void Function(String groupId) onInviteTap;
  final void Function(String groupId) onAcceptInvite;
  final void Function(String groupId) onDeclineInvite;

  @override
  Widget build(BuildContext context) {
    if (invites.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...invites.map((invite) => _buildInviteCard(invite)),
      ],
    );
  }

  Widget _buildInviteCard(GroupInvite invite) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodySmallText(
            'Invited by ${invite.invitedBy}',
            color: FamilyAppTheme.neutral50,
          ),
          Container(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: FunButton.destructiveSecondary(
                  onTap: () => onDeclineInvite(invite.group.id),
                  text: 'Decline',
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.groupInviteDeclined,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FunButton(
                  onTap: () => onAcceptInvite(invite.group.id),
                  text: 'Accept',
                  analyticsEvent: AnalyticsEvent(
                    AmplitudeEvents.groupInviteAccepted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
