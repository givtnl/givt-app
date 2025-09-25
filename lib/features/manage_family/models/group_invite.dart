import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';

class GroupInvite extends Equatable {
  const GroupInvite({
    required this.group,
    required this.invitedBy,
    required this.invitedAt,
  });

  factory GroupInvite.fromImpactGroup(ImpactGroup group) {
    return GroupInvite(
      group: group,
      invitedBy: group.organiser.firstName, // Use firstName instead of name
      invitedAt: DateTime.now(), // We don't have this info from the API, using current time
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': group.id,
      'groupName': group.name,
      'groupDescription': group.description,
      'groupImage': group.image,
      'invitedBy': invitedBy,
      'invitedAt': invitedAt.toIso8601String(),
    };
  }

  GroupInvite copyWith({
    ImpactGroup? group,
    String? invitedBy,
    DateTime? invitedAt,
  }) {
    return GroupInvite(
      group: group ?? this.group,
      invitedBy: invitedBy ?? this.invitedBy,
      invitedAt: invitedAt ?? this.invitedAt,
    );
  }

  final ImpactGroup group;
  final String invitedBy;
  final DateTime invitedAt;

  @override
  List<Object?> get props => [
        group,
        invitedBy,
        invitedAt,
      ];
}
