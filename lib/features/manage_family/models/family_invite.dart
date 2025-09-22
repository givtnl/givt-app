import 'package:equatable/equatable.dart';

class FamilyInvite extends Equatable {
  const FamilyInvite({
    required this.id,
    required this.email,
    required this.invitedBy,
    required this.createdAt,
    this.expiresAt,
    this.status = FamilyInviteStatus.pending,
    this.message,
  });

  factory FamilyInvite.fromJson(Map<String, dynamic> json) {
    return FamilyInvite(
      id: json['id'] as String,
      email: json['email'] as String,
      invitedBy: json['invitedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      status: FamilyInviteStatus.fromString(json['status'] as String? ?? 'pending'),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'invitedBy': invitedBy,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'status': status.value,
      'message': message,
    };
  }

  FamilyInvite copyWith({
    String? id,
    String? email,
    String? invitedBy,
    DateTime? createdAt,
    DateTime? expiresAt,
    FamilyInviteStatus? status,
    String? message,
  }) {
    return FamilyInvite(
      id: id ?? this.id,
      email: email ?? this.email,
      invitedBy: invitedBy ?? this.invitedBy,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  final String id;
  final String email;
  final String invitedBy;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final FamilyInviteStatus status;
  final String? message;

  @override
  List<Object?> get props => [
        id,
        email,
        invitedBy,
        createdAt,
        expiresAt,
        status,
        message,
      ];
}

enum FamilyInviteStatus {
  pending('Pending'),
  accepted('Accepted'),
  declined('Declined'),
  expired('Expired');

  const FamilyInviteStatus(this.value);

  final String value;

  static FamilyInviteStatus fromString(String value) {
    return FamilyInviteStatus.values.firstWhere(
      (element) => element.value.toLowerCase() == value.toLowerCase(),
      orElse: () => FamilyInviteStatus.pending,
    );
  }
}
