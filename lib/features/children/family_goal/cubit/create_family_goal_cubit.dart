import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/family_goal/models/family_goal.dart';
import 'package:givt_app/features/children/family_goal/repositories/create_family_goal_repository.dart';

part 'create_family_goal_state.dart';

class CreateFamilyGoalCubit extends Cubit<CreateFamilyGoalState> {
  CreateFamilyGoalCubit(
    this._createFamilyGoalRepository,
  ) : super(const CreateFamilyGoalState());

  final CreateFamilyGoalRepository _createFamilyGoalRepository;

  void showOverview() =>
      emit(state.copyWith(status: FamilyGoalCreationStatus.overview));

  void showCause() =>
      emit(state.copyWith(status: FamilyGoalCreationStatus.cause));

  void showAmount() =>
      emit(state.copyWith(status: FamilyGoalCreationStatus.amount));

  void showConfirmation() =>
      emit(state.copyWith(status: FamilyGoalCreationStatus.confirmation));

  void selectCause({
    required String meduimId,
    required String organisationName,
  }) =>
      emit(
        state.copyWith(mediumId: meduimId, organisationName: organisationName),
      );

  void selectAmount({required num amount}) =>
      emit(state.copyWith(amount: amount));

  Future<void> createFamilyGoal() async {
    emit(state.copyWith(status: FamilyGoalCreationStatus.loading));

    try {
      await _createFamilyGoalRepository.createFamilyGoal(
        familyGoal: FamilyGoal(mediumId: state.mediumId, amount: state.amount),
      );

      emit(state.copyWith(status: FamilyGoalCreationStatus.confirmed));
    } catch (error, stackTrace) {
      LoggingInfo.instance
          .error(error.toString(), methodName: stackTrace.toString());
      emit(
        state.copyWith(
          status: FamilyGoalCreationStatus.confirmation,
          error: error.toString(),
        ),
      );
    }
  }
}
