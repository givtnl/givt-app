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
  List<Member> get children {
    return members.where((p) => p.type == 'Child').toList();
  }

  List<Member> get adults {
    return members.where((p) => p.type == 'Parent').toList();
  }

  bool get hasChildren {
    return children.isEmpty;
  }

  bool get isAdultSingle {
    return adults.length == 1;
  }

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
