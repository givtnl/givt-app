part of 'add_member_cubit.dart';

sealed class AddMemberState extends Equatable {
  const AddMemberState({
    this.child,
  });

  final Child? child;

  @override
  List<Object?> get props => [child];
}

final class AddMemberInitial extends AddMemberState {}

final class AddMemberUploadingState extends AddMemberState {}

class AddMemberInputState extends AddMemberState {
  const AddMemberInputState({
    super.child,
  });
}

class ConfirmVPCState extends AddMemberState {
  const ConfirmVPCState({
    super.child,
  });
}

class AddMemberExternalErrorState extends AddMemberState {
  const AddMemberExternalErrorState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [child, errorMessage];
}

class AddMemberSuccessState extends AddMemberState {
  const AddMemberSuccessState();
}
