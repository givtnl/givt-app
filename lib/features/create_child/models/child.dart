import 'package:equatable/equatable.dart';

class Child extends Equatable {
  const Child({
    required this.parentId,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.allowance,
    this.isChild = true,
  });

  final String parentId;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final int? allowance;
  final bool isChild;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isChild': isChild,
      'givingAllowance': allowance,
      'parent': {
        'parentId': parentId,
      }
    };
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, dateOfBirth, allowance, parentId];
}
