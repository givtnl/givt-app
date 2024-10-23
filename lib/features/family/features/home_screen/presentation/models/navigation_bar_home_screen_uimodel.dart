import 'package:givt_app/features/impact_groups/models/impact_group.dart';

class NavigationBarHomeScreenUIModel {
  const NavigationBarHomeScreenUIModel({
    this.profilePictureUrl,
    this.familyInviteGroup,
  });

  final String? profilePictureUrl;
  final ImpactGroup? familyInviteGroup;
}
