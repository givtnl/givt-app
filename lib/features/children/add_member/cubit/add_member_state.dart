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
    this.profiles = const [],
    this.error = '',
  });
  final AddMemberStateStatus status;
  final AddMemberFormStatus formStatus;
  final List<Profile> profiles;
  final String error;

  AddMemberState copyWith({
    AddMemberStateStatus? status,
    AddMemberFormStatus? formStatus,
    List<Profile>? profiles,
    String? error,
  }) {
    return AddMemberState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      profiles: profiles ?? this.profiles,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [profiles, status, formStatus, error];
}
