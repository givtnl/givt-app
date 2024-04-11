import 'package:equatable/equatable.dart';

class ImpactGroup extends Equatable {
  const ImpactGroup({
    required this.id,
    required this.name,
    required this.status,
    required this.type,
  });

  const ImpactGroup.empty()
      : this(
          id: '',
          name: '',
          status: ImpactGroupStatus.unknown,
          type: ImpactGroupType.unknown,
        );

  factory ImpactGroup.fromMap(Map<String, dynamic> map) {
    return ImpactGroup(
      id: map['id'] as String,
      name: map['name'] as String,
      status: ImpactGroupStatus.fromString(map['status'] as String),
      type: ImpactGroupType.fromString(map['type'] as String),
    );
  }

  final String id;
  final String name;
  final ImpactGroupStatus status;
  final ImpactGroupType type;

  @override
  List<Object?> get props => [id, name, status, type];

  String toJson() {
    return '''
    {
      "id": "$id",
      "name": "$name",
      "status": "$status",
      "type": "$type"
    }
    ''';
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
