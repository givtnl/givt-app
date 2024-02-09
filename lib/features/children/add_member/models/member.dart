import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';

class Member extends Equatable {
  const Member({
    this.firstName,
    this.lastName,
    this.age,
    this.dateOfBirth,
    this.allowance,
    this.key,
    this.type,
  });

  const Member.empty()
      : firstName = null,
        lastName = null,
        age = null,
        dateOfBirth = null,
        allowance = null,
        key = null,
        type = null;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        firstName: (json['firstName'] ?? '').toString(),
        lastName: (json['lastName'] ?? '').toString(),
        age: (json['age'] ?? 0) as int,
        dateOfBirth: DateTime.tryParse((json['dateOfBirth'] ?? '') as String),
        allowance: (json['givingAllowance'] ?? 0) as int,
        type: ProfileType.getByTypeName((json['type'] ?? '') as String),
      );

  final String? firstName;
  final String? lastName;
  final int? age;
  final DateTime? dateOfBirth;
  final int? allowance;
  final String? key;
  final ProfileType? type;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'givingAllowance': allowance,
      'type': type?.name,
    };
  }

  bool get isAdult => type == ProfileType.Parent;
  bool get isChild => type == ProfileType.Child;

  @override
  List<Object?> get props =>
      [firstName, lastName, age, dateOfBirth, allowance, type];
}
