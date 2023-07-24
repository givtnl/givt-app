import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/create_child/models/child.dart';
import 'package:givt_app/features/create_child/repositories/create_child_repository.dart';

part 'create_child_state.dart';

class CreateChildCubit extends Cubit<CreateChildState> {
  CreateChildCubit(this._createChildRepository)
      : super(const CreateChildInputDataState());

  final CreateChildRepository _createChildRepository;

  void updateInputData({
    required String name,
    required double allowance,
    required bool showAllowanceDetails,
    DateTime? dateOfBirth,
  }) {
    emit(
      CreateChildInputDataState(
        name: name,
        allowance: allowance,
        dateOfBirth: dateOfBirth,
        isAllowanceDetailsVisible: showAllowanceDetails,
      ),
    );
  }

  Future<void> createChild({required Child child}) async {
    emit(CreateChildUploadingState());
    try {
      await _createChildRepository.createChild(child);
      emit(CreateChildSuccessState());
    } catch (error) {
      emit(
        CreateChildErrorState(error: error.toString()),
      );
    }
  }
}
