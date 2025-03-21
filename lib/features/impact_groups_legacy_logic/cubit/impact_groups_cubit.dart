import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/give/repositories/campaign_repository.dart';
import 'package:givt_app/features/family/features/impact_groups/models/goal.dart';
import 'package:givt_app/features/family/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups_legacy_logic/repo/impact_groups_repository.dart';

part 'impact_groups_state.dart';

class ImpactGroupsCubit extends Cubit<ImpactGroupsState> {
  ImpactGroupsCubit(
    this._impactGroupInviteRepository,
    this._campaignRepository,
  ) : super(const ImpactGroupsState()) {
    _init();
  }

  final ImpactGroupsRepository _impactGroupInviteRepository;
  final CampaignRepository _campaignRepository;

  StreamSubscription<List<ImpactGroup>>? _impactGroupsSubscription;

  void _init() {
    _impactGroupsSubscription =
        _impactGroupInviteRepository.onImpactGroupsChanged().listen(
      (impactGroups) {
        fetchImpactGroups();
      },
    );
  }

  Future<void> fetchImpactGroups() async {
    emit(state.copyWith(status: ImpactGroupCubitStatus.loading));

    try {
      final impactGroups = await _impactGroupInviteRepository.getImpactGroups();

      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.fetched,
          impactGroups: impactGroups,
        ),
      );
      await getImpactGroupOrganisation();
    } catch (e) {
      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.error,
          error: e.toString(),
        ),
      );
      LoggingInfo.instance.error(
        'Fetching impact groups failed: $e',
        methodName: 'fetchImpactGroups',
      );
    }
  }

  Future<void> getImpactGroupOrganisation() async {
    try {
      final impactGroups = state.impactGroups;
      for (final group in state.impactGroups) {
        if (group.goal != const Goal.empty() &&
            group.goal.mediumId.isNotEmpty) {
          final organisation = await _campaignRepository
              .getCachedOrganisation(group.goal.mediumId);

          impactGroups[impactGroups.indexWhere((e) => e.id == group.id)] =
              group.copyWith(organisation: organisation);
        }
      }
      emit(
        state.copyWith(
          impactGroups: impactGroups,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.error,
          error: e.toString(),
        ),
      );
      LoggingInfo.instance.error(
        'Adding organisation to impact group failed: $e',
        methodName: 'fetchImpactGroups',
      );
    }
  }

  void checkForInvites() {
    for (var i = 0; i < state.impactGroups.length; i++) {
      if (state.impactGroups[i].status == ImpactGroupStatus.invited) {
        emit(
          state.copyWith(
            status: ImpactGroupCubitStatus.invited,
            invitedGroup: state.impactGroups[i],
          ),
        );
        break;
      }
    }
  }

  Future<void> acceptGroupInvite({
    required String groupId,
  }) async {
    emit(state.copyWith(status: ImpactGroupCubitStatus.loading));
    try {
      await _impactGroupInviteRepository.acceptGroupInvite(
        groupId: groupId,
      );
      await fetchImpactGroups();
    } catch (e) {
      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.error,
          error: e.toString(),
        ),
      );
      LoggingInfo.instance.error(
        'Accept impact group invite failed $e',
        methodName: 'acceptGroupInvite',
      );
    }
  }

  void dismissGoal(String id) {
    emit(
      state.copyWith(dismissedGoalId: id),
    );
  }

  Future<void> refresh() async {
    await _impactGroupInviteRepository.refreshImpactGroups();
  }

  @override
  Future<void> close() async {
    await _impactGroupsSubscription?.cancel();
    await super.close();
  }
}
