part of 'create_child_cubit.dart';

abstract class CreateChildState extends Equatable {
  const CreateChildState({
    this.child,
  });

  final Child? child;

  @override
  List<Object?> get props => [child];
}

class CreateChildInputState extends CreateChildState {
  const CreateChildInputState({
    super.child,
  });
}

class CreateChildExternalErrorState extends CreateChildState {
  const CreateChildExternalErrorState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [child, errorMessage];
}

class CreateChildSuccessState extends CreateChildState {
  const CreateChildSuccessState({
    super.child,
  });
}

class CreateChildUploadingState extends CreateChildState {}
