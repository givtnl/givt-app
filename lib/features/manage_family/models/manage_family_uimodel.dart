import 'package:equatable/equatable.dart';
import 'package:givt_app/features/manage_family/models/family_invite.dart';
import 'package:givt_app/features/manage_family/models/family_member.dart';

class ManageFamilyUIModel extends Equatable {
  const ManageFamilyUIModel({
    required this.members,
    required this.invites,
    required this.isLoading,
    required this.errorMessage,
  });

  factory ManageFamilyUIModel.initial() {
    return const ManageFamilyUIModel(
      members: [],
      invites: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  factory ManageFamilyUIModel.loading() {
    return const ManageFamilyUIModel(
      members: [],
      invites: [],
      isLoading: true,
      errorMessage: null,
    );
  }

  factory ManageFamilyUIModel.error(String errorMessage) {
    return ManageFamilyUIModel(
      members: const [],
      invites: const [],
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  ManageFamilyUIModel copyWith({
    List<FamilyMember>? members,
    List<FamilyInvite>? invites,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ManageFamilyUIModel(
      members: members ?? this.members,
      invites: invites ?? this.invites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasMembers => members.isNotEmpty;
  bool get hasInvites => invites.isNotEmpty;
  bool get hasPendingInvites => invites.any((invite) => invite.status == FamilyInviteStatus.pending);
  bool get hasError => errorMessage != null;

  final List<FamilyMember> members;
  final List<FamilyInvite> invites;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        members,
        invites,
        isLoading,
        errorMessage,
      ];
}
