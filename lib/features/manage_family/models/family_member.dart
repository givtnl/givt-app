import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  const FamilyMember({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar,
    this.isActive = false,
    this.role = FamilyMemberRole.member,
    this.inviteStatus = FamilyMemberInviteStatus.none,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      role: FamilyMemberRole.fromString(json['role'] as String? ?? 'member'),
      inviteStatus: FamilyMemberInviteStatus.fromString(json['inviteStatus'] as String? ?? 'none'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar,
      'isActive': isActive,
      'role': role.value,
      'inviteStatus': inviteStatus.value,
    };
  }

  FamilyMember copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? avatar,
    bool? isActive,
    FamilyMemberRole? role,
    FamilyMemberInviteStatus? inviteStatus,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      inviteStatus: inviteStatus ?? this.inviteStatus,
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;
  final bool isActive;
  final FamilyMemberRole role;
  final FamilyMemberInviteStatus inviteStatus;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        avatar,
        isActive,
        role,
        inviteStatus,
      ];
}

enum FamilyMemberRole {
  admin('Admin'),
  member('Member');

  const FamilyMemberRole(this.value);

  final String value;

  static FamilyMemberRole fromString(String value) {
    return FamilyMemberRole.values.firstWhere(
      (element) => element.value.toLowerCase() == value.toLowerCase(),
      orElse: () => FamilyMemberRole.member,
    );
  }
}

enum FamilyMemberInviteStatus {
  none('None'),
  pending('Pending'),
  accepted('Accepted'),
  declined('Declined');

  const FamilyMemberInviteStatus(this.value);

  final String value;

  static FamilyMemberInviteStatus fromString(String value) {
    return FamilyMemberInviteStatus.values.firstWhere(
      (element) => element.value.toLowerCase() == value.toLowerCase(),
      orElse: () => FamilyMemberInviteStatus.none,
    );
  }
}
