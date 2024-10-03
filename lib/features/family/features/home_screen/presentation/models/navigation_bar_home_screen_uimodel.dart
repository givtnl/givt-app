import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';

class NavigationBarHomeScreenUIModel {
  const NavigationBarHomeScreenUIModel({
    this.profilePictureUrl,
    this.cachedMembers,
    this.familyInviteGroup,
  });

  final String? profilePictureUrl;
  final List<Member>? cachedMembers;
  final ImpactGroup? familyInviteGroup;
}
