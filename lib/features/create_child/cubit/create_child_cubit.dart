import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/create_child/models/child.dart';
import 'package:givt_app/features/create_child/repositories/create_child_repository.dart';

part 'create_child_state.dart';

class CreateChildCubit extends Cubit<CreateChildState> {
  CreateChildCubit(this._createChildRepository)
      : super(const CreateChildInputState());

  static const int _firstNameMinLength = 3;

  final CreateChildRepository _createChildRepository;

  bool _validateInput(Child child) {
    String? nameErrorMessage;
    String? dateErrorMessage;
    String? allowanceErrorMessage;

    final trimmedName = child.firstName != null ? child.firstName!.trim() : '';
    final allowance = child.allowance != null ? child.allowance! : 0.0;

    if (trimmedName.length < _firstNameMinLength) {
      //TODO: POEditor
      nameErrorMessage =
          'Name must be at least $_firstNameMinLength characters.';
    }

    if (child.dateOfBirth == null) {
      //TODO: POEditor
      dateErrorMessage = 'Please select date of birth.';
    }

    if (allowance <= 0) {
      //TODO: POEditor
      allowanceErrorMessage = 'Giving allowance must be grater then zero.';
    }

    if (nameErrorMessage != null ||
        dateErrorMessage != null ||
        allowanceErrorMessage != null) {
      emit(
        CreateChildInputErrorState(
          child: child,
          nameErrorMessage: nameErrorMessage,
          dateErrorMessage: dateErrorMessage,
          allowanceErrorMessage: allowanceErrorMessage,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> createChild({required Child child}) async {
    if (!_validateInput(child)) {
      return;
    }
    emit(CreateChildUploadingState());
    try {
      final isChildCreated = await _createChildRepository.createChild(child);
      if (isChildCreated) {
        emit(CreateChildSuccessState(child: child));
      } else {
        //TODO: POEditor
        throw Exception('Cannot create child profile. Please try again later.');
      }
    } catch (error) {
      emit(
        CreateChildExternalErrorState(errorMessage: error.toString()),
      );
    }
  }
}
