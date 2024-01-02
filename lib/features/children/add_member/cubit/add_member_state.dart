part of 'add_member_cubit.dart';

enum AddMemberStateStatus {
  initial,
  input,
  loading,
  success,
  error,
  vpc,
}

class AddMemberState extends Equatable {
  const AddMemberState({
    this.status = AddMemberStateStatus.initial,
    this.child = const Child.empty(),
    this.error = '',
  });
  final AddMemberStateStatus status;
  final Child child;
  final String error;

  AddMemberState copyWith({
    AddMemberStateStatus? status,
    Child? child,
    String? error,
  }) {
    return AddMemberState(
      status: status ?? this.status,
      child: child ?? this.child,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [child, status, error];
}
