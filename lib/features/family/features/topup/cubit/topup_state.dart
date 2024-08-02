part of 'topup_cubit.dart';

enum TopupStatus { initial, loading, done, error }

class TopupState extends Equatable {
  const TopupState({
    this.userGuid = '',
    this.amount = 0,
    this.status = TopupStatus.initial,
    this.error = '',
  });

  final String userGuid;
  final int amount;
  final TopupStatus status;
  final String error;

  @override
  List<Object> get props => [userGuid, amount, status, error];
  
  TopupState copyWith({
    String? userGuid,
    int? amount,
    TopupStatus? status,
    String? error,
  }) {
    return TopupState(
      userGuid: userGuid ?? this.userGuid,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
