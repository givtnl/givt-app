import 'package:equatable/equatable.dart';

class Member extends Equatable {
  const Member.empty()
      : firstName = null,
        lastName = null,
        age = null,
        dateOfBirth = null,
        allowance = null,
        key = null,
        type = null;

  const Member({
    this.firstName,
    this.lastName,
    this.age,
    this.dateOfBirth,
    this.allowance,
    this.key,
    this.type,
  });

  final String? firstName;
  final String? lastName;
  final int? age;
  final DateTime? dateOfBirth;
  final int? allowance;
  final String? key;
  final String? type;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'givingAllowance': allowance,
      'Type': type
    };
  }

  @override
  List<Object?> get props => [firstName, lastName, dateOfBirth, allowance];
}
