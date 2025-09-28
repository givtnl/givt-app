import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  const FamilyMember({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.type,
    this.avatar,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    // Extract avatar from picture.pictureURL structure
    String? avatar;
    if (json['picture'] != null) {
      final picture = json['picture'] as Map<String, dynamic>;
      avatar = picture['pictureURL'] as String?;
    }

    return FamilyMember(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      type: FamilyMemberType.fromString(json['type'] as String? ?? 'parent'),
      avatar: avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'type': type.value,
      'picture': avatar != null ? {'pictureURL': avatar} : null,
    };
  }

  FamilyMember copyWith({
    String? id,
    String? firstName,
    String? lastName,
    FamilyMemberType? type,
    String? avatar,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      type: type ?? this.type,
      avatar: avatar ?? this.avatar,
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  final String id;
  final String firstName;
  final String lastName;
  final FamilyMemberType type;
  final String? avatar;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        type,
        avatar,
      ];
}

enum FamilyMemberType {
  parent('parent'),
  child('child');

  const FamilyMemberType(this.value);

  final String value;

  static FamilyMemberType fromString(String value) {
    return FamilyMemberType.values.firstWhere(
      (element) => element.value.toLowerCase() == value.toLowerCase(),
      orElse: () => FamilyMemberType.parent,
    );
  }
}
