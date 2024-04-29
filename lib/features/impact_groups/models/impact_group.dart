import 'package:equatable/equatable.dart';
import 'package:givt_app/features/impact_groups/models/goal.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/features/impact_groups/models/group_organiser.dart';

class ImpactGroup extends Equatable {
  const ImpactGroup({
    required this.id,
    required this.name,
    required this.status,
    required this.type,
    required this.description,
    required this.image,
    required this.amountOfMembers,
    required this.organiser,
    required this.goal,
    required this.organisation,
  });

  const ImpactGroup.empty()
      : this(
          id: '',
          name: '',
          status: ImpactGroupStatus.unknown,
          type: ImpactGroupType.unknown,
          description: '',
          image: '',
          amountOfMembers: 0,
          organiser: const GroupOrganiser.empty(),
          goal: const Goal.empty(),
          organisation: const Organisation.empty(),
        );

  factory ImpactGroup.fromMap(Map<String, dynamic> map) {
    return ImpactGroup(
      id: map['id'] as String,
      name: map['name'] as String,
      status: ImpactGroupStatus.fromString(map['status'] as String),
      type: ImpactGroupType.fromString(map['type'] as String),
      description: map['description'] as String? ?? '',
      image: map['image'] as String? ?? '',
      amountOfMembers: (map['numberOfMembers'] as num? ?? 0).toInt(),
      organiser: map['organiser'] != null
          ? GroupOrganiser.fromMap(map['organiser'] as Map<String, dynamic>)
          : const GroupOrganiser.empty(),
      goal: map['goal'] != null
          ? Goal.fromMap(map['goal'] as Map<String, dynamic>)
          : const Goal.empty(),
      organisation: const Organisation.empty(),
    );
  }

  bool get isFamilyGroup => type == ImpactGroupType.family;

  final String id;
  final String name;
  final ImpactGroupStatus status;
  final ImpactGroupType type;
  final String description;
  final String image;
  final int amountOfMembers;
  final GroupOrganiser organiser;
  final Goal goal;
  final Organisation organisation;

  ImpactGroup copyWith({
    String? id,
    String? name,
    ImpactGroupStatus? status,
    ImpactGroupType? type,
    String? description,
    String? image,
    int? amountOfMembers,
    GroupOrganiser? organiser,
    Goal? goal,
    Organisation? organisation,
  }) {
    return ImpactGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      type: type ?? this.type,
      description: description ?? this.description,
      image: image ?? this.image,
      amountOfMembers: amountOfMembers ?? this.amountOfMembers,
      organiser: organiser ?? this.organiser,
      goal: goal ?? this.goal,
      organisation: organisation ?? this.organisation,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        type,
        description,
        image,
        amountOfMembers,
        organiser,
        goal,
        organisation,
      ];
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
  general('General'),
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
