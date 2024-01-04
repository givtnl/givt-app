part of 'add_member_cubit.dart';

enum AddMemberStateStatus {
  initial,
  input,
  loading,
  success,
  error,
  vpc,
}

enum AddMemberFormStatus {
  initial,
  validate,
  success,
  error,
}

class AddMemberState extends Equatable {
  const AddMemberState({
    this.status = AddMemberStateStatus.initial,
    this.formStatus = AddMemberFormStatus.initial,
    this.children = const [],
    this.error = '',
  });
  final AddMemberStateStatus status;
  final AddMemberFormStatus formStatus;
  final List<Child> children;
  final String error;

  AddMemberState copyWith({
    AddMemberStateStatus? status,
    AddMemberFormStatus? formStatus,
    List<Child>? children,
    String? error,
  }) {
    return AddMemberState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      children: children ?? this.children,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [children, status, formStatus, error];
}
