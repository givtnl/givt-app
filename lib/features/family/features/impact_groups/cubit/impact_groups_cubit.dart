import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/impact_groups/model/goal.dart';
import 'package:givt_app/features/family/features/impact_groups/model/impact_group.dart';
import 'package:givt_app/features/family/features/impact_groups/repository/impact_groups_repository.dart';

part 'impact_groups_state.dart';

class ImpactGroupsCubit extends Cubit<ImpactGroupsState> {
  ImpactGroupsCubit(
    this._impactGroupInviteRepository,
  ) : super(const ImpactGroupsState());

  final ImpactGroupsRepository _impactGroupInviteRepository;

  String dissmissedGoalKey(String childId) {
    return '$childId-dissmissedGoalKey';
  }

  Future<void> fetchImpactGroups(
    String guid, [
    bool forceLoading = false,
  ]) async {
    emit(
      state.copyWith(
        error: '',
        groups: forceLoading ? [] : state.groups,
        status: ImpactGroupCubitStatus.loading,
      ),
    );

    try {
      final impactGroups =
          await _impactGroupInviteRepository.fetchImpactGroups(guid);

      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.fetched,
          groups: impactGroups,
        ),
      );
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while fetching impact groups: $error',
        methodName: stackTrace.toString(),
      );
      emit(
        state.copyWith(
          groups: [],
          status: ImpactGroupCubitStatus.error,
          error: error.toString(),
        ),
      );
    }
  }
}
