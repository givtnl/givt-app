import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/create_child/mixins/mixins.dart';
import 'package:givt_app/features/children/create_child/models/child.dart';
import 'package:givt_app/features/children/create_child/repositories/create_child_repository.dart';
import 'package:givt_app/l10n/l10n.dart';

part 'create_child_state.dart';

class CreateChildCubit extends Cubit<CreateChildState>
    with
        ChildNameValidator,
        ChildDateOfBirthValidator,
        ChildGivingAllowanceValidator {
  CreateChildCubit(this._createChildRepository, this._locals)
      : super(const CreateChildInputState());

  final CreateChildRepository _createChildRepository;
  final AppLocalizations _locals;

  bool _validateInput(Child child) {
    final nameErrorMessage =
        validateName(locals: _locals, name: child.firstName);
    final dateErrorMessage =
        validateDateOfBirth(locals: _locals, dateOfBirth: child.dateOfBirth);
    final allowanceErrorMessage =
        validateGivingAllowance(locals: _locals, allowance: child.allowance);

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
        emit(
          CreateChildSuccessState(child: child),
        );
      } else {
        throw Exception(_locals.createChildErrorText);
      }
    } catch (error) {
      await LoggingInfo.instance.error(error.toString());

      emit(
        CreateChildExternalErrorState(errorMessage: error.toString()),
      );
    }
  }
}
