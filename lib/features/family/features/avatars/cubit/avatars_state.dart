part of 'avatars_cubit.dart';

enum AvatarsStatus { initial, loading, loaded, error }

class AvatarsState extends Equatable {
  const AvatarsState({
    this.status = AvatarsStatus.initial,
    this.avatars = const [],
    this.error = '',
  });

  final AvatarsStatus status;
  final List<Avatar> avatars;
  final String error;

  @override
  List<Object> get props => [status, avatars, error];

  AvatarsState copyWith({
    AvatarsStatus? status,
    List<Avatar>? avatars,
    String? error,
  }) {
    return AvatarsState(
      status: status ?? this.status,
      avatars: avatars ?? this.avatars,
      error: error ?? this.error,
    );
  }
}
