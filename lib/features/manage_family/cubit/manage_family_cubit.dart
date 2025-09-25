import 'package:givt_app/features/manage_family/models/family_invite.dart';
import 'package:givt_app/features/manage_family/models/family_member.dart';
import 'package:givt_app/features/manage_family/models/group_invite.dart';
import 'package:givt_app/features/manage_family/models/manage_family_custom.dart';
import 'package:givt_app/features/manage_family/models/manage_family_uimodel.dart';
import 'package:givt_app/features/manage_family/repository/manage_family_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

/// Cubit responsible for managing EU family management state.
/// Uses [ManageFamilyRepository] for fetching family data and managing invites.
class ManageFamilyCubit
    extends CommonCubit<ManageFamilyUIModel, ManageFamilyCustom> {
  ManageFamilyCubit(this._repository) : super(const BaseState.loading());

  final ManageFamilyRepository _repository;

  List<FamilyMember>? _members;
  List<FamilyInvite>? _familyInvites;
  List<GroupInvite>? _groupInvites;

  Future<void> init() async {
    // Listen to data changes
    _repository.onMembersChanged().listen((members) {
      print('DEBUG: Members changed: ${members.length} members');
      _members = members;
      emitData(_createUIModel());
    });

    _repository.onInvitesChanged().listen((familyInvites) {
      print('DEBUG: Family invites changed: ${familyInvites.length} invites');
      _familyInvites = familyInvites;
      emitData(_createUIModel());
    });

    _repository.onGroupInvitesChanged().listen((groupInvites) {
      print('DEBUG: Group invites changed: ${groupInvites.length} invites');
      _groupInvites = groupInvites;
      emitData(_createUIModel());
    });

    await loadFamilyData();
  }

  Future<void> loadFamilyData() async {
    emitLoading();

    await Future.wait([
      _repository.getFamilyMembers(),
      _repository.getFamilyInvites(),
      _repository.getGroupInvites(),
    ]);
  }

  Future<void> acceptGroupInvite(String groupId) async {
    await inTryCatchFinally(
      inTry: () async {
        await _repository.acceptGroupInvite(groupId);
        emitSnackbarMessage('Group invite accepted');
      },
      inCatch: (e, s) async {
        emitSnackbarMessage(
          'Failed to accept invite: ${e.toString()}',
          isError: true,
        );
      },
    );
  }

  Future<void> declineGroupInvite(String groupId) async {
    await inTryCatchFinally(
      inTry: () async {
        await _repository.declineGroupInvite(groupId);
        emitSnackbarMessage('Group invite declined');
      },
      inCatch: (e, s) async {
        emitSnackbarMessage(
          'Failed to decline invite: ${e.toString()}',
          isError: true,
        );
      },
    );
  }

  Future<void> removeFamilyMember(String memberId) async {
    await inTryCatchFinally(
      inTry: () async {
        await _repository.removeFamilyMember(memberId);
        emitSnackbarMessage('Member removed');
      },
      inCatch: (e, s) async {
        emitSnackbarMessage(
          'Failed to remove member: ${e.toString()}',
          isError: true,
        );
      },
    );
  }

  Future<void> updateMemberRole(String memberId, FamilyMemberRole role) async {
    await inTryCatchFinally(
      inTry: () async {
        await _repository.updateMemberRole(memberId, role);
        emitSnackbarMessage('Member role updated');
      },
      inCatch: (e, s) async {
        emitSnackbarMessage(
          'Failed to update role: ${e.toString()}',
          isError: true,
        );
      },
    );
  }

  Future<void> createFamilyInvite(String email, {String? message}) async {
    await inTryCatchFinally(
      inTry: () async {
        await _repository.createFamilyInvite(email, message: message);
        emitSnackbarMessage('Invite sent to $email');
      },
      inCatch: (e, s) async {
        emitSnackbarMessage(
          'Failed to send invite: ${e.toString()}',
          isError: true,
        );
      },
    );
  }

  Future<void> cancelFamilyInvite(String inviteId) async {
    await inTryCatchFinally(
      inTry: () async {
        await _repository.cancelFamilyInvite(inviteId);
        emitSnackbarMessage('Invite cancelled');
      },
      inCatch: (e, s) async {
        emitSnackbarMessage(
          'Failed to cancel invite: ${e.toString()}',
          isError: true,
        );
      },
    );
  }

  void navigateToCreateInvite() {
    emitCustom(const NavigateToCreateInvite());
  }

  void showGroupInviteDialog(String groupId) {
    emitCustom(ShowGroupInviteDialog(groupId));
  }

  void showMemberOptionsDialog(String memberId) {
    emitCustom(ShowMemberOptionsDialog(memberId));
  }

  void refreshFamilyData() {
    emitCustom(const RefreshFamilyData());
  }

  ManageFamilyUIModel _createUIModel() {
    print(
      'DEBUG: Creating UI model with ${_members?.length} members, ${_familyInvites?.length} family invites, and ${_groupInvites?.length} group invites',
    );
    return ManageFamilyUIModel(
      members: _members ?? [],
      familyInvites: _familyInvites ?? [],
      groupInvites: _groupInvites ?? [],
      isLoading: false,
      errorMessage: null,
    );
  }
}
