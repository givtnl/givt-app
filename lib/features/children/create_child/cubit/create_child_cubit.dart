import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/create_child/models/child.dart';
import 'package:givt_app/features/children/create_child/repositories/create_child_repository.dart';
import 'package:givt_app/l10n/l10n.dart';

part 'create_child_state.dart';

class CreateChildCubit extends Cubit<CreateChildState> {
  CreateChildCubit(this._createChildRepository, this._locals)
      : super(const CreateChildInputState());

  static const int _firstNameMinLength = 3;

  final CreateChildRepository _createChildRepository;
  final AppLocalizations _locals;

  bool _validateInput(Child child) {
    String? nameErrorMessage;
    String? dateErrorMessage;
    String? allowanceErrorMessage;

    final trimmedName = child.firstName != null ? child.firstName!.trim() : '';
    final allowance = child.allowance != null ? child.allowance! : 0.0;

    if (trimmedName.length < _firstNameMinLength) {
      nameErrorMessage =
          '${_locals.createChildNameErrorTextFirstPart1}$_firstNameMinLength${_locals.createChildNameErrorTextFirstPart2}';
    }

    if (child.dateOfBirth == null) {
      dateErrorMessage = _locals.createChildDateErrorText;
    }

    if (allowance <= 0) {
      allowanceErrorMessage = _locals.createChildAllowanceErrorText;
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
        throw Exception(_locals.createChildErrorText);
      }
    } catch (error) {
      emit(
        CreateChildExternalErrorState(errorMessage: error.toString()),
      );
    }
  }
}
