import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';

class NavigationBarHomeScreenUIModel {
  const NavigationBarHomeScreenUIModel({
    this.familyInviteGroup,
    this.showMemoriesTab = true,
  });

  final ImpactGroup? familyInviteGroup;
  final bool showMemoriesTab;
}
