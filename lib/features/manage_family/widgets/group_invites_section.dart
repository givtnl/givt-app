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
        TitleMediumText(
          'Group Invites',
          color: FamilyAppTheme.primary20,
        ),
        const SizedBox(height: 16),
        ...invites.map((invite) => _buildInviteCard(invite)),
      ],
    );
  }

  Widget _buildInviteCard(GroupInvite invite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: FunCard(
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Group image placeholder
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: FamilyAppTheme.primary10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: invite.group.image.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              invite.group.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultIcon(),
                            ),
                          )
                        : _buildDefaultIcon(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleSmallText(
                          invite.group.name,
                          color: FamilyAppTheme.primary20,
                        ),
                        const SizedBox(height: 4),
                        BodySmallText(
                          'Invited by ${invite.invitedBy}',
                          color: FamilyAppTheme.neutral50,
                        ),
                        if (invite.group.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          BodySmallText(
                            invite.group.description,
                            color: FamilyAppTheme.neutral50,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FunButton(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Icon(
      Icons.group,
      color: FamilyAppTheme.primary20,
      size: 24,
    );
  }
}
