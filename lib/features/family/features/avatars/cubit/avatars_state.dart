part of 'avatars_cubit.dart';

enum AvatarsStatus { initial, loading, loaded, error }

class AvatarsState extends Equatable {
  const AvatarsState({
    this.status = AvatarsStatus.initial,
    this.avatars = const [],
    this.assignedAvatars = const [],
    this.error = '',
  });

  final AvatarsStatus status;
  final List<Avatar> avatars;
  final List<Map<String, Avatar>> assignedAvatars;
  final String error;

  @override
  List<Object> get props => [status, avatars, assignedAvatars, error];

  Avatar getAvatarByKey(String key) {
    final assignment = assignedAvatars
        .firstWhere((element) => element.containsKey(key), orElse: () => {});

    return assignment[key] ?? const Avatar.empty();
  }

  AvatarsState copyWith({
    AvatarsStatus? status,
    List<Avatar>? avatars,
    List<Map<String, Avatar>>? assignedAvatars,
    String? error,
  }) {
    return AvatarsState(
      status: status ?? this.status,
      avatars: avatars ?? this.avatars,
      assignedAvatars: assignedAvatars ?? this.assignedAvatars,
      error: error ?? this.error,
    );
  }
}
