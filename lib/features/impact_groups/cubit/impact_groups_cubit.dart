import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:givt_app/features/impact_groups/repo/impact_groups_repository.dart';

part 'impact_groups_state.dart';

class ImpactGroupsCubit extends Cubit<ImpactGroupsState> {
  ImpactGroupsCubit(
    this._impactGroupInviteRepository,
    this._authCubit,
  ) : super(const ImpactGroupsState()) {
    _authCubit.stream.listen((event) async {
      // this stops the cubit from executing when an invited user
      // finished registraion and is now in the user extention refresh loop
      // see _onStripeSuccess in registration_bloc.dart
      if ((event.user.tempUser && !event.user.isInvitedUser) ||
          state.status == ImpactGroupCubitStatus.loading) {
        return;
      }
      if (event.status == AuthStatus.authenticated &&
          event.user.country == Country.us.countryCode) {
        await fetchImpactGroups();
        checkForInvites();
      }
    });
  }
  final ImpactGroupsRepository _impactGroupInviteRepository;
  final AuthCubit _authCubit;
  Future<void> fetchImpactGroups() async {
    emit(state.copyWith(status: ImpactGroupCubitStatus.loading));

    try {
      final impactGroups =
          await _impactGroupInviteRepository.fetchImpactGroups();

      emit(
        state.copyWith(
          status: ImpactGroupCubitStatus.fetched,
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
      unawaited(
        LoggingInfo.instance.error(
          'Fetching impact groups failed: $e',
          methodName: 'fetchImpactGroups',
        ),
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
      unawaited(
        LoggingInfo.instance.error(
          'Accept impact group invite failed $e',
          methodName: 'acceptGroupInvite',
        ),
      );
    }
  }
}
