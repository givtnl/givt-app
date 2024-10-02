import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';

sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showPreferredChurchDialog() =
      PreferredChurchDialog;

  const factory NavigationBarHomeCustom.userNeedsRegistration() =
      UserNeedsRegistration;

  const factory NavigationBarHomeCustom.familyNotSetup() = FamilyNotSetup;

  const factory NavigationBarHomeCustom.showCachedMembersDialog(
    List<Member> cachedMembers,
  ) = ShowCachedMembersDialog;

  const factory NavigationBarHomeCustom.showFamilyInvite(ImpactGroup group) =
      ShowFamilyInvite;
}

class PreferredChurchDialog extends NavigationBarHomeCustom {
  const PreferredChurchDialog();
}

class UserNeedsRegistration extends NavigationBarHomeCustom {
  const UserNeedsRegistration();
}

class ShowCachedMembersDialog extends NavigationBarHomeCustom {
  const ShowCachedMembersDialog(this.cachedMembers);

  final List<Member> cachedMembers;
}

class FamilyNotSetup extends NavigationBarHomeCustom {
  const FamilyNotSetup();
}

class ShowFamilyInvite extends NavigationBarHomeCustom {
  const ShowFamilyInvite(this.group);

  final ImpactGroup group;
}
