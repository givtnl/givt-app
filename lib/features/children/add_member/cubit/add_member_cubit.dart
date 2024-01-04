import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/child.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  AddMemberCubit(this._addMemberRepository) : super(const AddMemberState());
  final AddMemberRepository _addMemberRepository;

// to do add many children
  void rememberChild({required Child child}) {
    final existingChildIndex =
        state.children.indexWhere((c) => c.key == child.key);

    if (existingChildIndex != -1) {
      // Child with the same key exists, replace it
      final updatedChildren = state.children;
      updatedChildren[existingChildIndex] = child;

      emit(
        state.copyWith(
          children: updatedChildren,
          status: AddMemberStateStatus.input,
        ),
      );
    } else {
      // Child with the key doesn't exist, add it
      emit(
        state.copyWith(
          children: state.children..add(child),
          status: AddMemberStateStatus.input,
        ),
      );
    }
  }

  void validateForms() {
    emit(
      state.copyWith(
        status: AddMemberStateStatus.input,
        formStatus: AddMemberFormStatus.validate,
      ),
    );
  }

  void resetFormStatus() {
    emit(
      state.copyWith(
        status: AddMemberStateStatus.input,
        formStatus: AddMemberFormStatus.initial,
      ),
    );
  }

// TODO: display children in the forms when navigating back from VPC
// or navigate all the way back to the family overview page
  void goToInput() {
    emit(state.copyWith(
      status: AddMemberStateStatus.input,
      formStatus: AddMemberFormStatus.initial,
      children: [],
    ));
  }

  Future<void> createChildWithVPC() async {
    final children = state.children;
    emit(
      state.copyWith(
        status: AddMemberStateStatus.loading,
      ),
    );
    try {
      final isChildCreated = await _addMemberRepository.addMembers(children);
      if (isChildCreated) {
        emit(
          state.copyWith(
            status: AddMemberStateStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AddMemberStateStatus.error,
            error: 'Something went wrong',
          ),
        );
      }
    } catch (error) {
      await LoggingInfo.instance.error(error.toString());
      emit(
        state.copyWith(
          status: AddMemberStateStatus.error,
          error: error.toString(),
        ),
      );
    }
  }
}
