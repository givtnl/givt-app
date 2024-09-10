part of 'edit_child_cubit.dart';

abstract class EditChildState extends Equatable {
  const EditChildState({
    this.child = const EditChild.empty(),
  });

  final EditChild child;

  @override
  List<Object?> get props => [child];
}

class EditChildInitialState extends EditChildState {
  const EditChildInitialState();
}

class EditChildInputState extends EditChildState {
  const EditChildInputState({
    required this.profileDetails,
    required super.child,
  });
  final Profile profileDetails;
}

class EditChildInputErrorState extends EditChildState {
  const EditChildInputErrorState({
    required this.profileDetails,
    required super.child,
    this.nameErrorMessage,
    this.allowanceErrorMessage,
  });

  final Profile profileDetails;
  final String? nameErrorMessage;
  final String? allowanceErrorMessage;

  @override
  List<Object?> get props =>
      [profileDetails, child, nameErrorMessage, allowanceErrorMessage];
}

class EditChildExternalErrorState extends EditChildState {
  const EditChildExternalErrorState({
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class EditChildSuccessState extends EditChildState {
  const EditChildSuccessState();
}

class EditChildUploadingState extends EditChildState {
  const EditChildUploadingState();
}
