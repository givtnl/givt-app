part of 'topup_cubit.dart';

enum TopupStatus { initial, loading, done, error }

class TopupState extends Equatable {
  const TopupState({
    this.userGuid = '',
    this.status = TopupStatus.initial,
    this.error = '',
  });

  final String userGuid;
  final TopupStatus status;
  final String error;

  @override
  List<Object> get props => [userGuid, status, error];

  TopupState copyWith({
    String? userGuid,
    TopupStatus? status,
    String? error,
  }) {
    return TopupState(
      userGuid: userGuid ?? this.userGuid,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
