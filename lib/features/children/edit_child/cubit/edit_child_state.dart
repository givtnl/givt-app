part of 'edit_child_cubit.dart';

abstract class EditChildState extends Equatable {
  const EditChildState({
    this.profileDetails = const ProfileExt.empty(),
    this.child = const EditChild.empty(),
  });

  final ProfileExt profileDetails;
  final EditChild child;

  @override
  List<Object?> get props => [profileDetails, child];
}

class EditChildInitialState extends EditChildState {
  const EditChildInitialState();
}

class EditChildInputState extends EditChildState {
  const EditChildInputState({
    required super.profileDetails,
    required super.child,
  });
}

class EditChildInputErrorState extends EditChildState {
  const EditChildInputErrorState({
    required super.profileDetails,
    required super.child,
    this.nameErrorMessage,
    this.allowanceErrorMessage,
  });

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
  List<Object?> get props => [profileDetails, errorMessage];
}

class EditChildSuccessState extends EditChildState {
  const EditChildSuccessState({required super.profileDetails});
}

class EditChildUploadingState extends EditChildState {
  const EditChildUploadingState();
}
