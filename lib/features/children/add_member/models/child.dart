import 'package:equatable/equatable.dart';

class Child extends Equatable {
  const Child.empty()
      : firstName = null,
        lastName = null,
        age = null,
        dateOfBirth = null,
        allowance = null,
        key = null;

  const Child({
    this.firstName,
    this.lastName,
    this.age,
    this.dateOfBirth,
    this.allowance,
    this.key,
  });

  final String? firstName;
  final String? lastName;
  final int? age;
  final DateTime? dateOfBirth;
  final int? allowance;
  final String? key;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'givingAllowance': allowance,
      'Type': 'Child'
    };
  }

  @override
  List<Object?> get props => [firstName, lastName, dateOfBirth, allowance];
}
