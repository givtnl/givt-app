import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/create_child/mixins/mixins.dart';
import 'package:givt_app/features/children/create_child/repositories/create_child_repository.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

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

    await AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.childEditSaveClicked,
      eventProperties: {
        'child_name': child.firstName,
        'giving_allowance': child.allowance,
      },
    );

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
        emit(
          EditChildExternalErrorState(
            errorMessage: _locals.childEditProfileErrorText,
          ),
        );
      }
    } catch (error) {
      await LoggingInfo.instance.error(error.toString());

      emit(
        EditChildExternalErrorState(errorMessage: error.toString()),
      );
    }
  }
}
