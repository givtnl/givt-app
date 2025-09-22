import 'package:flutter/material.dart';
import 'package:givt_app/features/manage_family/models/family_member.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class FamilyMembersSection extends StatelessWidget {
  const FamilyMembersSection({
    required this.members,
    required this.onMemberOptions,
    super.key,
  });

  final List<FamilyMember> members;
  final void Function(String memberId) onMemberOptions;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMediumText(
          'Members (${members.length})',
          color: FamilyAppTheme.primary20,
        ),
        ...members.map(_buildMemberCard),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Column(
      children: [
        SizedBox(height: 40),
        Icon(
          Icons.people_outline,
          size: 64,
          color: FamilyAppTheme.neutral60,
        ),
        SizedBox(height: 16),
        TitleMediumText(
          'No Family Members Yet',
          color: FamilyAppTheme.neutral50,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        BodyMediumText(
          'Invite family members to join your giving journey',
          color: FamilyAppTheme.neutral60,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMemberCard(FamilyMember member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: FamilyAppTheme.neutralVariant95, // Light grey border
            ),
          ),
        ),
        child: Row(
          children: [
            FunAvatar.family(),
            const SizedBox(width: 16),
            Text(member.fullName),
          ],
        ),
      ),
    );
  }
}
