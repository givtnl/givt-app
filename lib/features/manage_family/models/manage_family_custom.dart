import 'package:equatable/equatable.dart';

sealed class ManageFamilyCustom extends Equatable {
  const ManageFamilyCustom();

  @override
  List<Object?> get props => [];
}

class NavigateToCreateInvite extends ManageFamilyCustom {
  const NavigateToCreateInvite();
}

class ShowInviteDialog extends ManageFamilyCustom {
  const ShowInviteDialog(this.inviteId);

  final String inviteId;

  @override
  List<Object?> get props => [inviteId];
}

class ShowMemberOptionsDialog extends ManageFamilyCustom {
  const ShowMemberOptionsDialog(this.memberId);

  final String memberId;

  @override
  List<Object?> get props => [memberId];
}

class RefreshFamilyData extends ManageFamilyCustom {
  const RefreshFamilyData();
}
