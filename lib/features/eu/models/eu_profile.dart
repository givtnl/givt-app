import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/user_ext.dart';

class EuProfile extends Equatable {
  const EuProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.isActive,
    required this.userExt,
  });

  factory EuProfile.fromUserExt(UserExt userExt, {bool isActive = false}) {
    return EuProfile(
      id: userExt.guid,
      email: userExt.email,
      firstName: userExt.firstName,
      lastName: userExt.lastName,
      profilePicture: userExt.profilePicture,
      isActive: isActive,
      userExt: userExt,
    );
  }

  factory EuProfile.empty() {
    return EuProfile(
      id: '',
      email: '',
      firstName: '',
      lastName: '',
      profilePicture: '',
      isActive: false,
      userExt: const UserExt.empty(),
    );
  }

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final bool isActive;
  final UserExt userExt;

  String get displayName {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    } else {
      return email;
    }
  }

  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  EuProfile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profilePicture,
    bool? isActive,
    UserExt? userExt,
  }) {
    return EuProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      isActive: isActive ?? this.isActive,
      userExt: userExt ?? this.userExt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        profilePicture,
        isActive,
        userExt,
      ];
}