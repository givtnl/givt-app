part of 'create_child_cubit.dart';

abstract class CreateChildState extends Equatable {
  const CreateChildState({
    this.name = '',
    this.dateOfBirth,
    this.allowance = 0,
    this.isAllowanceDetailsVisible = false,
  });

  final String name;
  final DateTime? dateOfBirth;
  final double allowance;

  final bool isAllowanceDetailsVisible;

  @override
  List<Object?> get props =>
      [name, dateOfBirth, allowance, isAllowanceDetailsVisible];
}

class CreateChildInputDataState extends CreateChildState {
  const CreateChildInputDataState({
    super.name,
    super.dateOfBirth,
    super.allowance,
    super.isAllowanceDetailsVisible,
  });

  bool get isFilled {
    return name.length > 1 && dateOfBirth != null && allowance > 0;
  }

  // CreateChildInputDataState copyWith({
  //   String? name,
  //   DateTime? dateOfBirth,
  //   double? allowance,
  //   bool? isAllowanceDetailsVisible,
  // }) {
  //   return CreateChildInputDataState(
  //     name: name ?? this.name,
  //     dateOfBirth: dateOfBirth ?? this.dateOfBirth,
  //     allowance: allowance ?? this.allowance,
  //     isAllowanceDetailsVisible:
  //         isAllowanceDetailsVisible ?? this.isAllowanceDetailsVisible,
  //   );
  // }
}

class CreateChildErrorState extends CreateChildState {
  const CreateChildErrorState({required this.error});
  final String error;

  @override
  List<Object?> get props =>
      [name, dateOfBirth, allowance, isAllowanceDetailsVisible, error];
}

class CreateChildSuccessState extends CreateChildState {}

class CreateChildUploadingState extends CreateChildState {}
