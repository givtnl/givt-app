import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';

class Member extends Equatable {
  const Member({
    this.firstName,
    this.lastName,
    this.age,
    this.dateOfBirth,
    this.allowance,
    this.pictureURL,
    this.pictureName,
    this.key,
    this.type,
    this.email,
  });

  const Member.empty()
      : firstName = null,
        lastName = null,
        age = null,
        dateOfBirth = null,
        allowance = null,
        pictureURL = null,
        pictureName = null,
        key = null,
        type = null,
        email = null;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        firstName: (json['firstName'] ?? '').toString(),
        lastName: (json['lastName'] ?? '').toString(),
        age: (json['age'] ?? 0) as int,
        dateOfBirth: DateTime.tryParse((json['dateOfBirth'] ?? '') as String),
        allowance: (json['givingAllowance'] ?? 0) as int,
        type: ProfileType.getByTypeName((json['type'] ?? '') as String),
        email: (json['email'] ?? '').toString(),
        pictureName: json['profilePicture'] as String?,
        pictureURL: json['profilePictureUrl'] as String?,
      );

  final String? firstName;
  final String? lastName;
  final int? age;
  final DateTime? dateOfBirth;
  final int? allowance;
  final String? pictureName;
  final String? pictureURL;
  final String? key;
  final ProfileType? type;
  final String? email;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'givingAllowance': allowance,
      'type': type?.name,
      'email': email,
      'profilePicture': pictureName,
    };
  }

  bool get isAdult => type == ProfileType.Parent;
  bool get isChild => type == ProfileType.Child;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        age,
        dateOfBirth,
        allowance,
        type,
        email,
        pictureURL,
        pictureName,
      ];
}
