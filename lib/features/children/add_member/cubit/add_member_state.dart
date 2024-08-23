part of 'add_member_cubit.dart';

enum AddMemberStateStatus {
  initial,
  input,
  loading,
  success,
  successNoAllowances,
  successCached,
  error,
  vpc,
  continueWithoutVPC
}

class AddMemberState extends Equatable {
  const AddMemberState({
    this.status = AddMemberStateStatus.initial,
    this.members = const [],
    this.error = '',
  });
  final AddMemberStateStatus status;
  final List<Member> members;
  final String error;

  List<Member> get children {
    return members.where((p) => p.type == ProfileType.Child).toList();
  }

  List<Member> get adults {
    return members.where((p) => p.type == ProfileType.Parent).toList();
  }

  bool get hasChildren {
    return children.isNotEmpty;
  }

  bool get isAdultSingle {
    return adults.length == 1;
  }

  AddMemberState copyWith({
    AddMemberStateStatus? status,
    List<Member>? members,
    String? error,
  }) {
    return AddMemberState(
      status: status ?? this.status,
      members: members ?? this.members,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [members, status, error];
}
