import 'package:equatable/equatable.dart';

class GroupOrganiser extends Equatable {
  const GroupOrganiser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  const GroupOrganiser.empty()
      : this(
          id: '',
          firstName: '',
          lastName: '',
          avatar: '',
        );

  factory GroupOrganiser.fromMap(Map<String, dynamic> map) {
    return GroupOrganiser(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      avatar: map['avatar'] as String,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String avatar;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        avatar,
      ];
}
