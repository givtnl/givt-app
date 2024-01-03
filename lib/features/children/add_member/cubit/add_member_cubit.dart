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
    emit(
      state.copyWith(
        child: child,
        status: AddMemberStateStatus.input,
      ),
    );
  }

  void goToVPC(Child? child) {
    emit(state.copyWith(
      status: AddMemberStateStatus.vpc,
      child: child ?? state.child,
    ));
  }

  void goToInput() {
    emit(state.copyWith(
      status: AddMemberStateStatus.input,
    ));
  }

  Future<void> createChildWithVPC() async {
    final child = state.child;
    emit(
      state.copyWith(
        status: AddMemberStateStatus.loading,
      ),
    );
    try {
      final isChildCreated = await _addMemberRepository.createChild(child);
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
