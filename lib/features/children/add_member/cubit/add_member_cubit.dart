import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/profile.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';

part 'add_member_state.dart';

class AddMemberCubit extends Cubit<AddMemberState> {
  AddMemberCubit(this._addMemberRepository) : super(const AddMemberState());
  final AddMemberRepository _addMemberRepository;
  void decreaseNrOfForms() {
    emit(state.copyWith(
      nrOfForms: max(1, state.nrOfForms - 1),
    ));
  }

  void increaseNrOfForms() {
    emit(state.copyWith(
      nrOfForms: state.nrOfForms + 1,
    ));
  }

  void rememberProfile({required Member member}) {
    final existingChildIndex =
        state.members.indexWhere((p) => p.key == member.key);

    if (existingChildIndex != -1) {
      // Child with the same key exists, replace it
      final updatedChildren = state.members;
      updatedChildren[existingChildIndex] = member;

      emit(
        state.copyWith(
            members: updatedChildren,
            status: AddMemberStateStatus.input,
            formStatus: AddMemberFormStatus.initial),
      );
    } else {
      // Child with the key doesn't exist, add it
      emit(
        state.copyWith(
            members: List.from(state.members)..add(member),
            status: AddMemberStateStatus.input,
            formStatus: AddMemberFormStatus.initial),
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

  void allFormsFilled() {
    emit(
      state.copyWith(
        formStatus: AddMemberFormStatus.success,
        status: AddMemberStateStatus.vpc,
      ),
    );
  }

// TODO: display children in the forms when navigating back from VPC
// or navigate all the way back to the family overview page
  void goToInput() {
    emit(state.copyWith(
      status: AddMemberStateStatus.input,
      formStatus: AddMemberFormStatus.initial,
      members: [],
    ));
  }

  Future<void> createChildWithVPC() async {
    final children = state.members;
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
