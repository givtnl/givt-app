import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/create_child/mixins/child_giving_allowance_validator.dart';
import 'package:givt_app/features/children/create_child/mixins/child_name_validator.dart';
import 'package:givt_app/features/children/create_child/repositories/create_child_repository.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';
import 'package:givt_app/l10n/l10n.dart';

part 'edit_child_state.dart';

class EditChildCubit extends Cubit<EditChildState>
    with ChildNameValidator, ChildGivingAllowanceValidator {
  EditChildCubit(
    this._createChildRepository,
    this._locals,
    this._profileDetails,
  ) : super(const EditChildInitialState()) {
    Future.delayed(Duration.zero, () {
      emit(
        EditChildInputState(
          profileDetails: _profileDetails,
          child: EditChild.fromProfileDetails(_profileDetails),
        ),
      );
    });
  }

  final CreateChildRepository _createChildRepository;
  final AppLocalizations _locals;
  final ProfileExt _profileDetails;

  bool _validateInput(EditChild child) {
    final nameErrorMessage =
        validateName(locals: _locals, name: child.firstName);
    final allowanceErrorMessage =
        validateGivingAllowance(locals: _locals, allowance: child.allowance);

    if (nameErrorMessage != null || allowanceErrorMessage != null) {
      emit(
        EditChildInputErrorState(
          profileDetails: _profileDetails,
          child: child,
          nameErrorMessage: nameErrorMessage,
          allowanceErrorMessage: allowanceErrorMessage,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> editChild({required EditChild child}) async {
    if (!_validateInput(child)) {
      return;
    }
    emit(const EditChildUploadingState());
    try {
      final isChildUpdated = await _createChildRepository.editChild(
        _profileDetails.profile.id,
        child,
      );
      if (isChildUpdated) {
        emit(
          EditChildSuccessState(profileDetails: _profileDetails),
        );
      } else {
        //TODO: POEditor
        throw Exception('Cannot update child profile. Please try again later.');
      }
    } catch (error) {
      emit(
        EditChildExternalErrorState(errorMessage: error.toString()),
      );
    }
  }
}
