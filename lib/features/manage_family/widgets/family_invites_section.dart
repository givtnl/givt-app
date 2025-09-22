import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/manage_family/models/family_invite.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class FamilyInvitesSection extends StatelessWidget {
  const FamilyInvitesSection({
    required this.invites,
    required this.onInviteTap,
    required this.onCancelInvite,
    super.key,
  });

  final List<FamilyInvite> invites;
  final void Function(String inviteId) onInviteTap;
  final void Function(String inviteId) onCancelInvite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleMediumText(
              'Invites (${invites.length})',
              color: FamilyAppTheme.primary20,
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (invites.isEmpty) _buildEmptyState(),
        ...invites.map(_buildInviteCard),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Column(
      children: [
        SizedBox(height: 40),
        Icon(
          Icons.mail_outline,
          size: 64,
          color: FamilyAppTheme.neutral60,
        ),
        SizedBox(height: 16),
        TitleMediumText(
          'No Pending Invites',
          color: FamilyAppTheme.neutral50,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        BodyMediumText(
          'All your invites have been accepted or there are no pending invites',
          color: FamilyAppTheme.neutral60,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInviteCard(FamilyInvite invite) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: FunTile(
        borderColor: FamilyAppTheme.neutral80,
        backgroundColor: FamilyAppTheme.neutral100,
        textColor: FamilyAppTheme.primary20,
        iconPath: 'assets/images/family_superheroes.svg', // Default icon
        iconColor: FamilyAppTheme.primary40,
        assetSize: 48,
        onTap: () => onInviteTap(invite.id),
        titleMedium: invite.email,
        subtitle: _buildInviteSubtitle(invite),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        analyticsEvent: AnalyticsEvent(AmplitudeEvents.okClicked),
      ),
    );
  }

  String _buildInviteSubtitle(FamilyInvite invite) {
    final statusText = _getStatusText(invite);
    final timeText = _getTimeText(invite);

    if (timeText.isNotEmpty) {
      return '$statusText • $timeText';
    }
    return statusText;
  }

  String _getStatusText(FamilyInvite invite) {
    switch (invite.status) {
      case FamilyInviteStatus.pending:
        return 'Pending';
      case FamilyInviteStatus.accepted:
        return 'Accepted';
      case FamilyInviteStatus.declined:
        return 'Declined';
      case FamilyInviteStatus.expired:
        return 'Expired';
    }
  }

  String _getTimeText(FamilyInvite invite) {
    final now = DateTime.now();
    final difference = now.difference(invite.createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
