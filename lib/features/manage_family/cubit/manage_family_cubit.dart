import 'package:givt_app/features/manage_family/models/family_invite.dart';
import 'package:givt_app/features/manage_family/models/family_member.dart';
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
  List<FamilyInvite>? _invites;

  Future<void> init() async {
    // Listen to data changes
    _repository.onMembersChanged().listen((members) {
      print('DEBUG: Members changed: ${members.length} members');
      _members = members;
      emitData(_createUIModel());
    });

    _repository.onInvitesChanged().listen((invites) {
      print('DEBUG: Invites changed: ${invites.length} invites');
      _invites = invites;
      emitData(_createUIModel());
    });

    await loadFamilyData();
  }

  Future<void> loadFamilyData() async {
    emitLoading();

    await Future.wait([
      _repository.getFamilyMembers(),
      _repository.getFamilyInvites(),
    ]);
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

  void navigateToCreateInvite() {
    emitCustom(const NavigateToCreateInvite());
  }

  Future<void> sendInvite(String email, String message) async {
    await inTryCatchFinally(
      inTry: () async {
        await _repository.createFamilyInvite(email, message: message);
        emitCustom(const RefreshFamilyData());
      },
    );
  }

  void showInviteDialog(String inviteId) {
    emitCustom(ShowInviteDialog(inviteId));
  }

  void showMemberOptionsDialog(String memberId) {
    emitCustom(ShowMemberOptionsDialog(memberId));
  }

  void refreshFamilyData() {
    emitCustom(const RefreshFamilyData());
  }

  ManageFamilyUIModel _createUIModel() {
    print(
      'DEBUG: Creating UI model with ${_members?.length} members and ${_invites?.length} invites',
    );
    return ManageFamilyUIModel(
      members: _members ?? [],
      invites: _invites ?? [],
      isLoading: false,
      errorMessage: null,
    );
  }
}
