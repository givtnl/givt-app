import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/edit_child/mixins/mixins.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';
import 'package:givt_app/features/children/edit_child/repositories/edit_child_repository.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

part 'edit_child_state.dart';

class EditChildCubit extends Cubit<EditChildState>
    with ChildNameValidator, ChildGivingAllowanceValidator {
  EditChildCubit(
    this._editChildRepository,
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

  final EditChildRepository _editChildRepository;
  final AppLocalizations _locals;
  final Profile _profileDetails;

  bool _validateInput(String name) {
    final nameErrorMessage = validateName(locals: _locals, name: name);

    if (nameErrorMessage != null) {
      emit(
        EditChildInputErrorState(
          profileDetails: _profileDetails,
          nameErrorMessage: nameErrorMessage,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> editChild({required String name}) async {
    if (!_validateInput(name)) {
      return;
    }

    await AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.childEditSaveClicked,
      eventProperties: {
        'child_name': name,
      },
    );

    emit(const EditChildUploadingState());
    try {
      final isChildUpdated = await _editChildRepository.editChildName(
        _profileDetails.id,
        name,
      );
      if (isChildUpdated) {
        emit(
          const EditChildSuccessState(),
        );
      } else {
        emit(
          EditChildExternalErrorState(
            errorMessage: _locals.childEditProfileErrorText,
          ),
        );
      }
    } catch (error, stackTrace) {
      LoggingInfo.instance
          .error(error.toString(), methodName: stackTrace.toString());

      emit(
        EditChildExternalErrorState(errorMessage: error.toString()),
      );
    }
  }
}
