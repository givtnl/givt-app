import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';

sealed class NavigationBarHomeCustom {
  const NavigationBarHomeCustom();

  const factory NavigationBarHomeCustom.showPreferredChurchDialog() =
      PreferredChurchDialog;

  const factory NavigationBarHomeCustom.familyNotSetup() = FamilyNotSetup;
}

class PreferredChurchDialog extends NavigationBarHomeCustom {
  const PreferredChurchDialog();
}

class FamilyNotSetup extends NavigationBarHomeCustom {
  const FamilyNotSetup();
}
