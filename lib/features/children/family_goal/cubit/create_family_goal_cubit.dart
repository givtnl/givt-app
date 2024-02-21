import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/family_goal/models/family_goal.dart';
import 'package:givt_app/features/children/family_goal/repositories/create_family_goal_repository.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/shared/repositories/repositories.dart';

part 'create_family_goal_state.dart';

class CreateFamilyGoalCubit extends Cubit<CreateFamilyGoalState> {
  CreateFamilyGoalCubit(
    this._createFamilyGoalRepository,
    this._collectGroupRepository,
  ) : super(const CreateFamilyGoalState());

  final CreateFamilyGoalRepository _createFamilyGoalRepository;
  final CollectGroupRepository _collectGroupRepository;

  void moveToOverview() =>
      emit(state.copyWith(status: FamilyGoalCreationStatus.overview));

  Future<void> moveToCause() async {
    emit(state.copyWith(status: FamilyGoalCreationStatus.loading));
    final collectGroupList =
        await _collectGroupRepository.getCollectGroupList();

    final organisations = collectGroupList
        .where(
          (organisation) => organisation.accountType == AccountType.creditCard,
        )
        .toList();

    emit(
      state.copyWith(
        status: FamilyGoalCreationStatus.cause,
        collectGroupList: organisations,
        mediumId: '',
        organisationName: '',
      ),
    );
  }

  void moveToAmount({
    String? meduimId,
    String? organisationName,
  }) =>
      emit(
        state.copyWith(
          status: FamilyGoalCreationStatus.amount,
          mediumId: meduimId,
          organisationName: organisationName,
        ),
      );

  void moveToConfirmation({
    num? amount,
  }) =>
      emit(
        state.copyWith(
          status: FamilyGoalCreationStatus.confirmation,
          amount: amount,
          error: '',
        ),
      );

  void goBack() {
    emit(state.copyWith(status: state.status.previous));
  }

  Future<void> createFamilyGoal() async {
    emit(state.copyWith(status: FamilyGoalCreationStatus.loading));

    try {
      await _createFamilyGoalRepository.createFamilyGoal(
        familyGoal: FamilyGoal(mediumId: state.mediumId, amount: state.amount),
      );

      emit(state.copyWith(status: FamilyGoalCreationStatus.confirmed));
    } catch (error, stackTrace) {
      await LoggingInfo.instance
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
