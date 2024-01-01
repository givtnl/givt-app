import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/child.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  AddMemberCubit(this._addMemberRepository) : super(AddMemberInitial());
  final AddMemberRepository _addMemberRepository;

// to do add many children
  void rememberChild({required Child child}) {
    emit(AddMemberInputState(child: child));
  }

  void goToVPC({required Child child}) {
    emit(ConfirmVPCState(child: child));
  }

  void goToInput({required Child child}) {
    emit(AddMemberInputState(child: child));
  }

  Future<void> createChildWithVPC() async {
    if (state.child != null) {
      final child = state.child!;

      emit(AddMemberUploadingState());
      try {
        final isChildCreated = await _addMemberRepository.createChild(child);
        if (isChildCreated) {
          emit(
            const AddMemberSuccessState(),
          );
        } else {
          emit(
            const AddMemberExternalErrorState(errorMessage: 'error'),
          );
        }
      } catch (error) {
        await LoggingInfo.instance.error(error.toString());
        emit(
          AddMemberExternalErrorState(errorMessage: error.toString()),
        );
      }
    } else {
      emit(
        const AddMemberExternalErrorState(errorMessage: 'error'),
      );
    }
  }
}
