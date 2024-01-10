part of 'add_member_cubit.dart';

enum AddMemberStateStatus {
  initial,
  input,
  loading,
  success,
  error,
  vpc,
  continueWithoutVPC
}

enum AddMemberFormStatus {
  initial,
  validate,
  success,
}

class AddMemberState extends Equatable {
  const AddMemberState({
    this.status = AddMemberStateStatus.initial,
    this.formStatus = AddMemberFormStatus.initial,
    this.members = const [],
    this.nrOfForms = 1,
    this.error = '',
  });
  final AddMemberStateStatus status;
  final AddMemberFormStatus formStatus;
  final List<Member> members;
  final int nrOfForms;
  final String error;

  AddMemberState copyWith({
    AddMemberStateStatus? status,
    AddMemberFormStatus? formStatus,
    List<Member>? members,
    int? nrOfForms,
    String? error,
  }) {
    return AddMemberState(
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
      members: members ?? this.members,
      nrOfForms: nrOfForms ?? this.nrOfForms,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [members, status, formStatus, nrOfForms, error];
}
