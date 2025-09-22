import 'package:equatable/equatable.dart';

class EuProfile extends Equatable {
  const EuProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.isActive = false,
  });

  factory EuProfile.fromJson(Map<String, dynamic> json) {
    return EuProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'isActive': isActive,
    };
  }

  EuProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    bool? isActive,
  }) {
    return EuProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
    );
  }

  final String id;
  final String name;
  final String email;
  final String? avatar;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, email, avatar, isActive];
}
