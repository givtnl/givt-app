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
  void rememberChild({required Child child}) {
    emit(CreateChildInputState(child: child));
  }

  Future<void> createChild() async {
    if (state is CreateChildInputState) {
      Child child = state.child!;

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
    } else {
      emit(CreateChildExternalErrorState(
          errorMessage: _locals.createChildErrorText));
    }
  }
}
