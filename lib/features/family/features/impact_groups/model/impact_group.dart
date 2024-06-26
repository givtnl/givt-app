import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/impact_groups/model/goal.dart';
import 'package:givt_app/features/family/features/impact_groups/model/group_organiser.dart';

class ImpactGroup extends Equatable {
  const ImpactGroup({
    required this.id,
    required this.status,
    required this.type,
    required this.name,
    required this.description,
    required this.image,
    required this.amountOfMembers,
    required this.organiser,
    required this.goal,
  });

  const ImpactGroup.empty()
      : this(
          id: '',
          status: ImpactGroupStatus.unknown,
          type: ImpactGroupType.unknown,
          name: '',
          description: '',
          image: '',
          amountOfMembers: 0,
          organiser: const GroupOrganiser.empty(),
          goal: const Goal.empty(),
        );

  factory ImpactGroup.fromMap(Map<String, dynamic> map) {
    return ImpactGroup(
      id: map['id'] as String? ?? '',
      status: ImpactGroupStatus.fromString(map['status'] as String? ?? ''),
      type: ImpactGroupType.fromString(map['type'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      image: map['image'] as String? ?? '',
      amountOfMembers: (map['numberOfMembers'] as num? ?? 0).toInt(),
      organiser: map['organiser'] != null
          ? GroupOrganiser.fromMap(map['organiser'] as Map<String, dynamic>)
          : const GroupOrganiser.empty(),
      goal: map['goal'] != null
          ? Goal.fromMap(map['goal'] as Map<String, dynamic>)
          : const Goal.empty(),
    );
  }

  bool get isFamilyGroup => type == ImpactGroupType.family;

  final String id;
  final ImpactGroupStatus status;
  final ImpactGroupType type;
  final String name;
  final String description;
  final String image;
  final int amountOfMembers;
  final GroupOrganiser organiser;
  final Goal goal;

  @override
  List<Object?> get props => [
        id,
        status,
        type,
        name,
        description,
        image,
        amountOfMembers,
        organiser,
        goal,
      ];

  ImpactGroup copyWith({
    String? id,
    ImpactGroupStatus? status,
    ImpactGroupType? type,
    String? name,
    String? description,
    String? image,
    int? amountOfMembers,
    GroupOrganiser? organiser,
    Goal? goal,
  }) {
    return ImpactGroup(
      id: id ?? this.id,
      status: status ?? this.status,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      amountOfMembers: amountOfMembers ?? this.amountOfMembers,
      organiser: organiser ?? this.organiser,
      goal: goal ?? this.goal,
    );
  }
}

enum ImpactGroupStatus {
  invited('Invited'),
  accepted('Accepted'),
  unknown('Unknown');

  const ImpactGroupStatus(this.value);

  final String value;

  static ImpactGroupStatus fromString(String value) {
    return ImpactGroupStatus.values.firstWhere(
      (element) => element.value == value,
      orElse: () => ImpactGroupStatus.unknown,
    );
  }
}

enum ImpactGroupType {
  family('Family'),
  impact('Impact'),
  unknown('Unknown');

  const ImpactGroupType(this.value);

  final String value;

  static ImpactGroupType fromString(String value) {
    return ImpactGroupType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => ImpactGroupType.unknown,
    );
  }
}
