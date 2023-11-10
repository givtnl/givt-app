import 'package:equatable/equatable.dart';

class Child extends Equatable {
  const Child({
    required this.parentId,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.allowance,
  });

  final String parentId;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final int? allowance;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'givingAllowance': allowance,
      'parent': {
        'id': parentId,
      }
    };
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, dateOfBirth, allowance, parentId];
}
