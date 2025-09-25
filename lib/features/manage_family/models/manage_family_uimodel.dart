import 'package:equatable/equatable.dart';
import 'package:givt_app/features/manage_family/models/family_invite.dart';
import 'package:givt_app/features/manage_family/models/family_member.dart';
import 'package:givt_app/features/manage_family/models/group_invite.dart';

class ManageFamilyUIModel extends Equatable {
  const ManageFamilyUIModel({
    required this.members,
    required this.familyInvites,
    required this.groupInvites,
    required this.isLoading,
    required this.errorMessage,
  });

  factory ManageFamilyUIModel.initial() {
    return const ManageFamilyUIModel(
      members: [],
      familyInvites: [],
      groupInvites: [],
      isLoading: false,
      errorMessage: null,
    );
  }

  factory ManageFamilyUIModel.loading() {
    return const ManageFamilyUIModel(
      members: [],
      familyInvites: [],
      groupInvites: [],
      isLoading: true,
      errorMessage: null,
    );
  }

  factory ManageFamilyUIModel.error(String errorMessage) {
    return ManageFamilyUIModel(
      members: const [],
      familyInvites: const [],
      groupInvites: const [],
      isLoading: false,
      errorMessage: errorMessage,
    );
  }

  ManageFamilyUIModel copyWith({
    List<FamilyMember>? members,
    List<FamilyInvite>? familyInvites,
    List<GroupInvite>? groupInvites,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ManageFamilyUIModel(
      members: members ?? this.members,
      familyInvites: familyInvites ?? this.familyInvites,
      groupInvites: groupInvites ?? this.groupInvites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasMembers => members.isNotEmpty;
  bool get hasFamilyInvites => familyInvites.isNotEmpty;
  bool get hasGroupInvites => groupInvites.isNotEmpty;
  bool get hasError => errorMessage != null;

  final List<FamilyMember> members;
  final List<FamilyInvite> familyInvites;
  final List<GroupInvite> groupInvites;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        members,
        familyInvites,
        groupInvites,
        isLoading,
        errorMessage,
      ];
}
