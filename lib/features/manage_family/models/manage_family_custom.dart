import 'package:equatable/equatable.dart';

sealed class ManageFamilyCustom extends Equatable {
  const ManageFamilyCustom();

  @override
  List<Object?> get props => [];
}

class NavigateToCreateInvite extends ManageFamilyCustom {
  const NavigateToCreateInvite();
}

class ShowGroupInviteDialog extends ManageFamilyCustom {
  const ShowGroupInviteDialog(this.groupId);

  final String groupId;

  @override
  List<Object?> get props => [groupId];
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
