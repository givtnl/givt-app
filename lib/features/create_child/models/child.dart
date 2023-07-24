import 'package:equatable/equatable.dart';

class Child extends Equatable {
  const Child({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.parentId,
    this.isChild = true,
  });

  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String parentId;
  final bool isChild;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'isChild': isChild,
      'parent': {
        'parentId': parentId,
      }
    };
  }

  @override
  List<Object?> get props => [firstName, lastName, dateOfBirth, parentId];
}
